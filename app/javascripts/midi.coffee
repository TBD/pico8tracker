module.exports = class MIDI

	MIDIObject: 
		port: false
		messageEvent: false

	onMIDIMessage: (event) =>
		cmd = event.data[0] >> 4;
		channel = event.data[0] & 0xf;
		noteNumber = event.data[1];
		velocity = event.data[2];		
		@MIDIObject.messageEvent(cmd, channel, noteNumber, velocity)

	onMIDIStarted: (midi) =>
		console.log "start"
		midi.inputs.forEach (e) =>
			if e.name.match(/midi/i)
				console.log('MIDI: ', e.name)
				e.onmidimessage = @onMIDIMessage
				@MIDIObject.port = e
		false

	onMIDISystemError: ->
		console.log "error"

	constructor: ->
		navigator.requestMIDIAccess().then( @onMIDIStarted, @onMIDISystemError );
		return @MIDIObject