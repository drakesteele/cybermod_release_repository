

function PlaySound(file,path,channel,volume)
	
	
		
		if(channel == "env") then
			
			
			
			
			
			local o = io.open("env.json","w"):close()
			
			local f = io.open("env.json", "w")
			
			local obj = {}
			obj.path = path.."\\"..file
			obj.volume = volume
			
			
			local stringg = JSON:encode_pretty(obj)
		
			f:write(stringg)
			f:close()
		end
		
		
		if(channel == "music") then
			
			local MusicVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "MusicVolume")
			MusicVolume:SetValue(0)
			
			
			
			
			local CarRadioVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "CarRadioVolume")
			CarRadioVolume:SetValue(0)
			
			
			io.open("music.json","w"):close()
			
			local f = assert(io.open("music.json", "w"))
			local obj = {}
			obj.path = path.."\\"..file
			obj.volume = volume
			
			
			local stringg = JSON:encode_pretty(obj)
		
			f:write(stringg)
			f:close()
		end
		
		if(channel == "sound") then
			
		
			
			io.open("sound.json","w"):close()
			
			local f = assert(io.open("sound.json", "w"))
			local obj = {}
			obj.path = path.."\\"..file
			obj.volume = volume
			
			
			local stringg = JSON:encode_pretty(obj)
		
			f:write(stringg)
			f:close()
		end
		
		
		
	
	
end

function Pause(channel)
	
	
		
		if(channel == "env") then
		
		
			
			
			io.open("pauseenv.txt","w"):close()
			
			
		end
		
		
		if(channel == "music") then
			
			
			local MusicVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "MusicVolume")
			MusicVolume:SetValue(100)
			
			
			
			local CarRadioVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "CarRadioVolume")
			CarRadioVolume:SetValue(100)
			
		
		
		
			io.open("pausemusic.txt","w"):close()
			
		end
		
		if(channel == "sound") then
			
			
			
			
		
		
		
			io.open("pausesound.txt","w"):close()
			
		end
		
		
		
	
	
end

function Resume(channel)
	
	
		
		if(channel == "env") then
			
			
			
			
			
			os.remove("pauseenv.txt")
			
		end
		
		
		if(channel == "music") then
			
			local MusicVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "MusicVolume")
			MusicVolume:SetValue(0)
			
			
			
			local CarRadioVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "CarRadioVolume")
			CarRadioVolume:SetValue(0)
			
				os.remove("pausemusic.txt")
		end
		
		if(channel == "sound") then
			
			
				os.remove("pausesound.txt")
		end
		
		
		
	
	
end

function Stop(channel)
	
	
		
		if(channel == "env") then
			
		
			os.remove("pauseenv.txt")
				io.open("stopenv.txt","w"):close()
		end
		
		
		if(channel == "music") then
			
			local MusicVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "MusicVolume")
			MusicVolume:SetValue(100)
			
			
		
			local CarRadioVolume = Game.GetSettingsSystem():GetVar("/audio/volume", "CarRadioVolume")
			CarRadioVolume:SetValue(100)
			
					os.remove("pausemusic.txt")
				io.open("stopmusic.txt","w"):close()
		end
		
		if(channel == "sound") then
		
			
			
				os.remove("pausesound.txt")
				io.open("stopsound.txt","w"):close()
		end
		
		
		
	
	
end



function IsPlaying(channel)
	
local bool = false
	
		
		if(channel == "env") then
			
			
			local env = io.open("env.json")
			local lines = env:read("*a")
				
			if(lines ~= "") then
			
				bool = true
				
			
			end
			env:close()
		end
		
		if(channel == "music") then
			
			
			local f = io.open("music.json")
			local lines = f:read("*a")
				
			if(lines ~= "") then
			
				bool = true
				
			
			end
			f:close()
		end
		
		if(channel == "sound") then
			local f = io.open("sound.json")
			local lines = f:read("*a")
				
			if(lines ~= "") then
			
				bool = true
				
			
			end
			f:close()
		end
		
		return bool
	
	
end

function SetSoundSettingValue(volumTag,value)
	
	local SfxVolume = Game.GetSettingsSystem():GetVar("/audio/volume", volumTag)
	SoundManager.SfxVolume = SfxVolume:GetValue()
	SfxVolume:SetValue(value)
	
end


