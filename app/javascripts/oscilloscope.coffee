module.exports = class Oscilloscope
	constructor: (context, elem) ->
		elem = document.getElementById(elem)
		@analyser = context.createAnalyser()
		@analyser.width = elem.offsetWidth
		@analyser.height = elem.offsetHeight
		@analyser.lineColor = 'black'
		@analyser.lineThickness = 1

		svgNamespace = 'http://www.w3.org/2000/svg'
		paper = document.createElementNS(svgNamespace, 'svg')
		paper.setAttribute 'width', @analyser.width
		paper.setAttribute 'height', @analyser.height
		paper.setAttributeNS 'http://www.w3.org/2000/xmlns/', 'xmlns:xlink', 'http://www.w3.org/1999/xlink'
		elem.appendChild paper
		
		@oscLine = document.createElementNS(svgNamespace, 'path')
		@oscLine.setAttribute 'stroke', @analyser.lineColor
		@oscLine.setAttribute 'stroke-width', @analyser.lineThickness
		@oscLine.setAttribute 'fill', 'none'
		paper.appendChild @oscLine

		@drawLine()
		@analyser

	drawLine: =>
		noDataPoints = 5
		freqData = new Uint8Array(@analyser.frequencyBinCount)
		@analyser.getByteTimeDomainData freqData
		graphPoints = []
		graphStr = ''
		graphPoints.push 'M0, ' + @analyser.height / 2
		i = 0
		while i < freqData.length
			if i % noDataPoints
				point = freqData[i] / 128 *@analyser.height / 2
				graphPoints.push 'L' + i + ', ' + point
			i++
		i = 0
		while i < graphPoints.length
			graphStr += graphPoints[i]
			i++
		@oscLine.setAttribute 'stroke',@analyser.lineColor
		@oscLine.setAttribute 'stroke-width',@analyser.lineThickness
		@oscLine.setAttribute 'd', graphStr
		setTimeout @drawLine, 100
		return

