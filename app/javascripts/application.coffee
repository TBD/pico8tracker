MIDI = require "midi"
Oscilloscope = require "oscilloscope"

module.exports = class Application

	nodes: []

	noteOn: (frequency) ->
		oscillator = @context.createOscillator()
		oscillator.type = 'square'
		oscillator.frequency.value = frequency
		oscillator.connect(@masterGain)
		oscillator.start(0)
		@nodes.push(oscillator)

	noteOn_: (frequency) ->
		buffer = @context.createBuffer(1,@context.sampleRate,@context.sampleRate);
		data = buffer.getChannelData(0)

		x = 1
		for i in [0..data.length-1]
			x = x + frequency/@context.sampleRate	
			# data[i] = Math.sin(2 * Math.PI * x) * 0.25 # sin
			# data[i] = (x % 1 - 0.5) * 0.333 # saw
			# data[i] = (x % 2 < 0.5 and 1 or -1) * 0.25 # square
			# data[i] = 1 - 4 * Math.abs((x + 0.25) %1 - 0.5) #tri
			# data[i] = (x % 2 < 0.25 and 1 or -1) * 0.25 # pulse
			data[i] = (Math.abs((x%2)-1)-0.5 + (Math.abs(((x*0.5)%2)-1)-0.5)/2) * 0.333 # tri/2
			# data[i] = (Math.abs((x%2)-1)-0.5 + (Math.abs(((x*0.97)%2)-1)-0.5)/2) * 0.333

		oscillator = @context.createBufferSource()
		oscillator.buffer = buffer
		oscillator.loop = true
		oscillator.frequency = frequency # 'fake' to be able to noteOff later
		oscillator.connect(@masterGain)
		oscillator.start(0)
		@nodes.push(oscillator)

	noteOff: (frequency) ->
		new_nodes = []
		for i in [0..@nodes.length-1]
			if (Math.round(@nodes[i].frequency.value) == Math.round(frequency))
				@nodes[i].stop(0)
				@nodes[i].disconnect()
			else 
				new_nodes.push(@nodes[i])

		@nodes = new_nodes;		

	constructor: ->
		settings = 
			id: 'keyboard'
			width: 600
			height: 100
			startNote: 'C5'
			whiteNotesColour: '#fff'
			blackNotesColour: '#000'
			borderColour: '#000'
			activeColour: 'yellow'
			octaves: 2

		keyboard = new QwertyHancock(settings)

		window.midi = new MIDI
		midi.messageEvent = (cmd, channel, noteNumber, velocity) =>
			freq =  440 * Math.pow(2, (noteNumber - 33) / 12);

			if velocity is 0
				@noteOff freq
				return

			if cmd is 8
				@noteOff freq

			if cmd is 9
				@noteOn freq

		@context = new AudioContext
		@masterGain = @context.createGain()
		@masterGain.gain.value = 0.5

		@oscilloscope = new Oscilloscope(@context, 'oscilloscope').analyser
		@oscilloscope.connect(@context.destination)
		@masterGain.connect(@oscilloscope) 

		keyboard.keyDown = (note, frequency) =>
			@noteOn frequency

		keyboard.keyUp = (note, frequency) =>
			@noteOff frequency

