
root = exports ? this

Plot = () ->
  width = 600
  height = 600
  data = []
  points = null
  margin = {top: 0, right: 0, bottom: 0, left: 0}
  xScale = d3.scale.linear().domain([-5,5]).range([0,width])
  yScale = d3.scale.linear().domain([-5,5]).range([0,height])

  chart = (selection) ->
    selection.each (rawData) ->

      data = rawData
      data = d3.range(300).map () ->
        {xloc: 0, yloc: 0, xvel: 0, yvel: 0}

      svg = d3.select(this).selectAll("svg").data([data])
      gEnter = svg.enter().append("svg").append("g")

      svg.append("clipPath")
        .attr('id', 'hart_clip')
        .append('polygon')
        .attr('points', "300.916,577.839 2.494,297.721 2.494,124.406 151.517,17.738 300.521,110.96 449.915,17.747 599,124.396 
	599,297.721 ")
      
      svg.attr("width", width + margin.left + margin.right )
      svg.attr("height", height + margin.top + margin.bottom )

      g = svg.select("g")
        .attr("transform", "translate(#{margin.left},#{margin.top})")
        .attr('clip-path', "url(#hart_clip)")

      g.append("rect")
        .attr("width", width)
        .attr("height", height)

      points = g.append("g").attr("id", "vis_points")
      update()

  update = () ->
    circle = points.selectAll(".point")
      .data(data).enter()
      .append("circle")
      .attr("class", "point")
      .attr("cx", 10)
      .attr("cy", 10)
      .attr("r", 1)
      .attr("fill", "white")

    d3.timer () ->
      data.forEach (d) ->
        d.xloc += d.xvel
        d.yloc += d.yvel
        d.xvel += 0.04 * (Math.random() - .5) - 0.05 * d.xvel - 0.0005 * d.xloc
        d.yvel += 0.04 * (Math.random() - .5) - 0.05 * d.yvel - 0.0005 * d.yloc
      circle
        .attr("transform", (d) -> "translate(" + xScale(d.xloc) + "," + yScale(d.yloc) + ")")
        .attr("r", (d) -> Math.min(1 + 1000 * Math.abs(d.xvel * d.yvel), 10))
      false


  chart.height = (_) ->
    if !arguments.length
      return height
    height = _
    chart

  chart.width = (_) ->
    if !arguments.length
      return width
    width = _
    chart

  chart.margin = (_) ->
    if !arguments.length
      return margin
    margin = _
    chart

  chart.x = (_) ->
    if !arguments.length
      return xValue
    xValue = _
    chart

  chart.y = (_) ->
    if !arguments.length
      return yValue
    yValue = _
    chart

  return chart

root.Plot = Plot

root.plotData = (selector, data, plot) ->
  d3.select(selector)
    .datum(data)
    .call(plot)


$ ->

  plot = Plot()
  display = (error, data) ->
    plotData("#vis", data, plot)

  queue()
    .defer(d3.csv, "data/test.csv")
    .await(display)

