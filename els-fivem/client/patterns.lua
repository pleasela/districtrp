els_patterns = {}

function trafficAdvisor(elsVehicle, stage, pattern)
	Citizen.CreateThread(function()
		if (not IsEntityDead(elsVehicle) and DoesEntityExist(elsVehicle)) then
			if (doesVehicleHaveTrafficAdvisor(elsVehicle)) then
		        if(stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
		            if stage == 1 then
		                setExtraState(elsVehicle, 5, 1)
		                setExtraState(elsVehicle, 6, 1)
		            end

		            setExtraState(elsVehicle, 7, 1)
                    setExtraState(elsVehicle, 8, 1)
                    setExtraState(elsVehicle, 9, 1)

		            if (pattern == 1) then
	            		local count = 1
	                    while count <= 4 do
	                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                            break
	                        end
	                        if count == 1 then
	                            setExtraState(elsVehicle, 7, 0)
	                        end
	                        if count == 2 then
	                            setExtraState(elsVehicle, 8, 0)
	                        end
	                        if count == 3 then
	                            setExtraState(elsVehicle, 9, 0)
	                        end
	                        if count == 4 then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        Wait(200)
	                        count = count + 1
	                    end
		            end
		            if (pattern == 2) then
	                	local count = 1
	                    while count <= 4 do
	                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                            break
	                        end
	                        if count == 1 then
	                            setExtraState(elsVehicle, 9, 0)
	                        end
	                        if count == 2 then
	                            setExtraState(elsVehicle, 8, 0)
	                        end
	                        if count == 3 then
	                            setExtraState(elsVehicle, 7, 0)
	                        end
	                        if count == 4 then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        Wait(200)
	                        count = count + 1
	                    end
		            end
		            if (pattern == 3) then
	                	local count = 1
	                    while count <= 4 do
	                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                            break
	                        end
	                        if count == 1 then
	                            setExtraState(elsVehicle, 8, 0)
	                        end
	                        if count == 2 then
	                            setExtraState(elsVehicle, 9, 0)
	                            setExtraState(elsVehicle, 7, 0)
	                        end
	                        if count == 3 then
	                            setExtraState(elsVehicle, 8, 1)
	                        end
	                        if count == 4 then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        Wait(200)
	                        count = count + 1
	                    end
		            end
		            if (pattern == 4) then
	            		local count = 1
	                    while count <= 6 do
	                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                            break
	                        end
	                        if count == 1 then
	                            setExtraState(elsVehicle, 7, 0)
	                        end
	                        if count == 2 then
	                            setExtraState(elsVehicle, 8, 0)
	                        end
	                        if count == 3 then
	                            setExtraState(elsVehicle, 9, 0)
	                        end
	                        if count == 4 then
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        if count == 5 then
	                            setExtraState(elsVehicle, 9, 0)
	                        end
	                        if count == 6 then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        Wait(300)
	                        count = count + 1
	                    end
		            end
		            if (pattern == 5) then
	            		local count = 1
	                    while count <= 6 do
	                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                            break
	                        end
	                        if count == 1 then
	                            setExtraState(elsVehicle, 9, 0)
	                        end
	                        if count == 2 then
	                            setExtraState(elsVehicle, 8, 0)
	                        end
	                        if count == 3 then
	                            setExtraState(elsVehicle, 7, 0)
	                        end
	                        if count == 4 then
	                            setExtraState(elsVehicle, 7, 1)
	                        end
	                        if count == 5 then
	                            setExtraState(elsVehicle, 7, 0)
	                        end
	                        if count == 6 then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        Wait(300)
	                        count = count + 1
	                    end
		            end
		            if (pattern == 6) then
	            		local count = 1
	                    while count <= 6 do
	                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
	                            setExtraState(elsVehicle, 7, 1)
	                            setExtraState(elsVehicle, 8, 1)
	                            setExtraState(elsVehicle, 9, 1)
	                            break
	                        end
	                        if count == 1 then
	                            setExtraState(elsVehicle, 9, 0)
	                        end
	                        if count == 2 then
	                        	setExtraState(elsVehicle, 9, 1)
	                            setExtraState(elsVehicle, 7, 0)
	                        end
	                        if count == 3 then
	                            setExtraState(elsVehicle, 9, 0)
	                            setExtraState(elsVehicle, 7, 1)
	                        end
	                        if count == 4 then
	                            setExtraState(elsVehicle, 7, 0)
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        if count == 5 then
	                            setExtraState(elsVehicle, 9, 0)
	                            setExtraState(elsVehicle, 7, 1)
	                        end
	                        if count == 6 then
	                            setExtraState(elsVehicle, 7, 0)
	                            setExtraState(elsVehicle, 9, 1)
	                        end
	                        Wait(300)
	                        count = count + 1
	                    end
		            end
		        end
		    end
		end
	end)
end

function getNumberOfPrimaryPatterns()
	local count = 0
	for k,v in pairs(els_patterns) do
		if (v.primary ~= nil) then
			count = count + 1
		end
	end

	return count
end

function getNumberOfSecondaryPatterns()
	local count = 0
	for k,v in pairs(els_patterns) do
		if (v.secondary ~= nil) then
			count = count + 1
		end
	end

	return count
end

function runPatternStageThree(k, pattern, isReady, cb) 
	Citizen.CreateThread(function()
		if (not IsEntityDead(k) and DoesEntityExist(k) and isReady) then
			cb(false)
			
			local max = 0
			local count = 1

			for k,v in pairs(els_patterns[pattern].primary.stages) do
				max = max + 1
			end

			while count <= max do
				setExtraState(k, 1, els_patterns[pattern].primary.stages[count][1])
                setExtraState(k, 2, els_patterns[pattern].primary.stages[count][2])
                setExtraState(k, 3, els_patterns[pattern].primary.stages[count][3])
                setExtraState(k, 4, els_patterns[pattern].primary.stages[count][4])

				if(count == max) then
					cb(true)
				end
				Wait(els_patterns[pattern].primary.speed)
				count = count + 1
			end
		end
	end)
end

function runPatternStageTwo(k, pattern, isReady, cb) 
	Citizen.CreateThread(function()
		if (not IsEntityDead(k) and DoesEntityExist(k) and isReady) then
			cb(false)
			
			local max = 0
			local count = 1

			for k,v in pairs(els_patterns[pattern].secondary.stages) do
				max = max + 1
			end

			while count <= max do
				setExtraState(k, 5, els_patterns[pattern].secondary.stages[count][1])
                setExtraState(k, 6, els_patterns[pattern].secondary.stages[count][2])
                if (not doesVehicleHaveTrafficAdvisor(k)) then
                    setExtraState(k, 7, els_patterns[pattern].secondary.stages[count][3])
                    setExtraState(k, 9, els_patterns[pattern].secondary.stages[count][4])
                end

				if(count == max) then
					cb(true)
				end
				Wait(els_patterns[pattern].secondary.speed)
				count = count + 1
			end
		end
	end)
end