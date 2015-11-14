		# buffer = @context.createBuffer(1,@context.sampleRate,@context.sampleRate);
		# data = buffer.getChannelData(0)

		# x = 1
		# for i in [0..data.length-1]
		# 	x = x + frequency/@context.sampleRate	
		# 	data[i] = Math.sin(2 * Math.PI * x) * 0.25
		# 	# data[i] = (x % 1 - 0.5) * 0.333 # saw
		# 	# data[i] = (x % 2 < 0.5 and 1 or -1) * 0.25 # square
		# 	# data[i] = 1 - 4 * Math.abs((x + 0.25) %1 - 0.5) #tri
		# 	# data[i] = (x % 2 < 0.25 and 1 or -1) * 0.25 # pulse
		# 	# data[i] = (Math.abs((x%2)-1)-0.5 + (Math.abs(((x*0.5)%2)-1)-0.5)/2) * 0.333 # tri/2
		# 	# data[i] = (Math.abs((x%2)-1)-0.5 + (Math.abs(((x*0.97)%2)-1)-0.5)/2) * 0.333

		# oscillator = @context.createBufferSource()
		# oscillator.buffer = buffer
		# oscillator.loop = true