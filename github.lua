if not game:IsLoaded() then
    game.Loaded:Wait()
end

function request(options)
	assert(type(options) == "table", "invalid argument #1 to 'request' (table expected, got " .. type(options) .. ") ", 2)
	local Event = Instance.new("BindableEvent")
	local RequestInternal = game:GetService("HttpService").RequestInternal
	local Request = RequestInternal(game:GetService("HttpService"), options)
	local Start = Request.Start
	local Response
	Start(Request, function(state, response)
		Response = response
		Event:Fire()
	end)
	Event.Event:Wait()
	return Response
end

function HttpGet(url)
	assert(type(url) == "string", "invalid argument #1 to 'httpget' (string expected, got " .. type(url) .. ") ", 2)
    local response = request({
        Url = url;
        Method = "GET";
    }).Body
	task.wait() 
	return response
end

function HttpGetAsync(...)
    local b = table.concat({...}, " ")
 
    local a = {
        Url = "http://localhost:2024/httpget",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "text/plain"
        },
        Body = b
    }
    
    return request(a).Body
end

function loadstring(src, chunkname)
    local module = game.CoreGui.RobloxGui.Modules.Common.Text
    module = module:Clone()
    module.Name = "nyxss"
    module.Parent = game.CoreGui
 
    local options = {
        Url = "http://localhost:2024/loadstring",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "text/plain"
        },
        Body = "return function(...) " .. src .. "\nend"
    }
 
    request(options)

    module.Name = if chunkname then tostring(chunkname) else "nyxss"
    module.Parent = nil
    local woked, func = pcall(require, module)
    module:Destroy()
    if woked then
        setfenv(func, getfenv(1))
        return function(...)
            local worked, stuff = pcall(func, ...)
            if not worked then
                task.spawn(function()
                    error(stuff, 2)
                end)
                return nil, stuff
            else
                return stuff
            end
        end
    else
        return nil, func
    end
end


local temp_identity = 6

function printidentity()
    print("Current identity is 6")
end

function getspoofedidentity()
    print("Current identity is "..temp_identity)
end

function getthreadidentity()
    return temp_identity
end

function getidentity()
    return temp_identity
end

function getthreadcontext()
    return temp_identity
end

function setthreadidentity(a1)
    if (a1 > 8) then
        error("Current identity can not exceed 8", 2)
    else
        temp_identity = a1
        printidentity = getspoofedidentity
    end
end

function setthreadcontext(a1)
    if (a1 > 8) then
        error("Current identity cannot be over 8", 2)
    else
        temp_identity = a1
        printidentity = getspoofedidentity
    end
end

function setidentity(a1)
    if (a1 > 8) then
        error("Current identity cannot be over 8", 2)
    else
        temp_identity = a1
        printidentity = getspoofedidentity
    end
end

function getexecutorname()
    return "nyxss"
end

function getexecutorversion()
    return "6.0"
end

function identifyexecutor()
    return getexecutorname(), getexecutorversion()
end

function checkcaller()
	return getidentity() > 3
end

function isluau()
    return true
end

function fireproximityprompt(Obj, Amount, Skip)
	assert(typeof(Obj) == "Instance", "invalid argument #1 to 'fireproximityprompt' (ProximityPrompt expected, got " .. type(Spoof) .. ") ")
	assert(Obj.ClassName == "ProximityPrompt", "invalid argument #1 to 'fireproximityprompt' (ProximityPrompt expected, got " .. type(Spoof) .. ") ")
    assert(type(Amount) == "number", "invalid argument #2 to 'fireproximityprompt' (number expected, got " .. type(Amount) .. ") ", 2)
	Amount = Amount or 1
    local PromptTime = Obj.HoldDuration
    if Skip then
        Obj.HoldDuration = 0
    end
    for i = 1, Amount do
        Obj:InputHoldBegin()
        if not Skip then
            wait(Obj.HoldDuration)
        end
        Obj:InputHoldEnd()
    end
    Obj.HoldDuration = PromptTime
end

function fireclickdetector(part)
    local cd = part:FindFirstChild("ClickDetector") or part
    local old_parent = cd.Parent
    local p = Instance.new("Part")
    p.Transparency = 1
    p.Size = Vector3.new(30, 30, 30)
    p.Anchored = true
    p.CanCollide = false
    p.Parent = workspace
    cd.Parent = p
    cd.MaxActivationDistance = math.huge

    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        p.CFrame = workspace.Camera.CFrame * CFrame.new(0, 0, -20) * CFrame.new(workspace.Camera.CFrame.LookVector.X, workspace.Camera.CFrame.LookVector.Y, workspace.Camera.CFrame.LookVector.Z)
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(20, 20), workspace:FindFirstChildOfClass("Camera").CFrame)
    end)

    cd.MouseClick:Once(function()
        conn:Disconnect()
        cd.Parent = old_parent
        p:Destroy()
    end)
end

function getrunningscripts()
    local returnable = {}

    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            if not v:IsA("ModuleScript") and v.Enabled then
                returnable[#returnable + 1] = v
            elseif v:IsA("ModuleScript") then
                returnable[#returnable + 1] = v
            end
        end
    end

    return returnable
end

function getinstances()
	return game:GetDescendants()
end

function getscripts()
	local a = {}
	for i,v in pairs(getinstances()) do
		if v:IsA("LocalScript") or v:IsA("ModuleScript") then
			table.insert(a, v)
		end
	end
	return a
end

function getloadedmodules()
	local b = {}
	for i,v in pairs(getscripts()) do
		if v:IsA("ModuleScript") then
			table.insert(b, v)
		end
	end
	return b
end

function getscripthash(a)
    assert(typeof(a) == "Instance" and a:IsA("LuaSourceContainer"), "argument #1 is not a 'LuaSourceContainer'", 0)
    return a:GetHash()
end

function getgenv(a, b)
	return a and b and rawset(getfenv(), a, b) or rawget(getfenv(), a) or setmetatable({}, {__index = getfenv(),__newindex = function(self, index, value)getfenv()[index] = value end})
end

function gethui()
	return game:GetService("CoreGui")
end

function compareinstances(t1, t2)
    if t1 == t2 then
        return true
    end
    local Properties = {LinkedSource,Source,FontFace,LineHeight,MaxVisibleGraphemes,OpenTypeFeatures,RichText,Text,TextColor3,TextDirection,TextScaled,TextSize,TextStrokeColor3,TextStrokeTransparency,TextTransparency,TextTruncate,TextWrapped,TextXAlignment,TextYAlignment,Style,CFrame,Visible,MaxTextSize,MinTextSize,Image,ImageColor3,ImageRectOffset,ImageRectSize,ImageTransparency,ResampleMode,ScaleType,SliceCenter,SliceScale,TileSize,DoubleSided,MeshId,TextureID,Value,HorizontalFlex,ItemLineAlignment,Padding,VerticalFlex,Wraps,AutoJumpEnabled,CameraMaxZoomDistance,CameraMinZoomDistance,CameraMode,CanLoadCharacterAppearance,Character,CharacterAppearance,CharacterAppearanceId,DevCameraOcclusionMode,DevComputerCameraMode,DevComputerMovementMode,DevEnableMouseLock,DevTouchCameraMode,DevTouchMovementMode,DisplayName,GameplayPaused,HasVerifiedBadge,HealthDisplayDistance,NameDisplayDistance,Neutral,ReplicationFocus,RespawnLocation,TeamColor,UserId,userId,HoverImage,PressedImage,AnimationId,Stiffness,AutoRotate,AutomaticScalingEnabled,BreakJointsOnDeath,CameraOffset,CollisionType,DisplayDistanceType,EvaluateStateMachine,HealthDisplayType,HipHeight,JumpHeight,JumpPower,MaxHealth,MaxSlopeAngle,NameOcclusion,PlatformStand,RequiresNeck,RigType,Sit,TargetPoint,UseJumpPower,WalkSpeed,WalkToPart,WalkToPoint,PaddingBottom,PaddingLeft,PaddingRight,PaddingTop,ShirtTemplate,AccessoryBlob,BackAccessory,BodyTypeScale,ClimbAnimation,DepthScale,Face,FaceAccessory,FallAnimation,FrontAccessory,GraphicTShirt,HairAccessory,HatAccessory,Head,HeadColor,HeadScale,HeightScale,IdleAnimation,JumpAnimation,LeftArm,LeftArmColor,LeftLeg,LeftLegColor,MoodAnimation,NeckAccessory,Pants,ProportionScale,RightArm,RightArmColor,RightLeg,RightLegColor,RunAnimation,Shirt,ShouldersAccessory,SwimAnimation,Torso,TorsoColor,WaistAccessory,WalkAnimation,WidthScale,CornerRadius,EmitterSize,LoopRegion,Looped,MaxDistance,MinDistance,Pitch,PlayOnRemove,PlaybackRegion,PlaybackRegionsEnabled,RollOffMode,SoundGroup,SoundId,Volume,HeadColor3,LeftArmColor3,LeftLegColor3,RightArmColor3,RightLegColor3,TorsoColor3,Color3,Texture,Transparency,ZIndex,ApiKey,AutomaticCanvasSize,BottomImage,CanvasPosition,CanvasSize,ElasticBehavior,HorizontalScrollBarInset,MidImage,ScrollBarImageColor3,ScrollBarImageTransparency,ScrollBarThickness,ScrollingDirection,ScrollingEnabled,TopImage,VerticalScrollBarInset,VerticalScrollBarPosition,ClipToDeviceSafeArea,DisplayOrder,IgnoreGuiInset,SafeAreaCompatibility,ScreenInsets,AccessoryType,AssetId,Instance,IsLayered,Order,Position,Puffiness,Rotation,Scale,AspectRatio,AspectType,DominantAxis,Graphic,CanSend,MeshType,PantsTemplate,PreferLodEnabled,AutomaticScaling,AvatarGestures,ControllerModels,FadeOutViewOnCollision,LaserPointer,Active,Adornee,AlwaysOnTop,Brightness,ClipsDescendants,DistanceLowerLimit,DistanceStep,DistanceUpperLimit,ExtentsOffset,ExtentsOffsetWorldSpace,LightInfluence,PlayerToHideFrom,Size,SizeOffset,StudsOffset,StudsOffsetWorldSpace,BodyPart,Color,Enabled,Offset,ScreenOrientation,SelectionImageObject,AlphaMode,ColorMap,MetalnessMap,NormalMap,RoughnessMap,TexturePack,LevelOfDetail,ModelStreamingMode,PrimaryPart,AutocompleteVisible,PrimaryAlias,SecondaryAlias,AllowTeamChangeOnTouch,Duration,ClearTextOnFocus,CursorPosition,MultiLine,PlaceholderColor3,PlaceholderText,SelectionStart,ShowNativeInput,TextEditable,MaxSize,MinSize,AirDensity,AvatarUnificationMode,CSGAsyncDynamicCollision,ClientAnimatorThrottling,DecreaseMinimumPartDensityMode,FallenPartsDestroyHeight,FluidForces,GlobalWind,Gravity,IKControlConstraintSupport,MeshPartHeadsAndAccessories,ModelStreamingBehavior,MoverConstraintRootBehavior,PhysicsSteppingMethod,PlayerCharacterDestroyBehavior,PrimalPhysicsSolver,RejectCharacterDeletions,RenderingCacheOptimizations,ReplicateInstanceDestroySetting,Retargeting,SignalBehavior,StreamOutBehavior,StreamingEnabled,StreamingIntegrityMode,StreamingMinRadius,StreamingTargetRadius,TouchesUseCollisionGroups,MaxPromptsVisible,IsCaptureModeForReport,AutoRuns,Description,ExecuteWithStudioRun,IsSleepAllowed,NumberOfPlayers,SimulateSecondsLag,Timeout,SourceLocaleId,AutoUpdate,DefaultName,SerializedDefaultAttributes,GamepadCursorEnabled,Ambient,ColorShift_Bottom,ColorShift_Top,EnvironmentDiffuseScale,EnvironmentSpecularScale,ExposureCompensation,FogColor,FogEnd,FogStart,GeographicLatitude,GlobalShadows,OutdoorAmbient,Outlines,ShadowSoftness,Technology,TimeOfDay,MaxItems,AllowClientInsertModels,LineThickness,SurfaceColor3,SurfaceTransparency,CellPadding,CellSize,FillDirectionMaxCells,StartCorner,ApplyStrokeMode,LineJoinMode,Thickness,GroupColor3,GroupTransparency,ResolutionScale,AutocompleteEnabled,BackgroundColor3,BackgroundTransparency,KeyboardKeyCode,TargetTextChannel,TextBox,AdorneeName,BubbleDuration,BubblesSpacing,LocalPlayerStudsOffset,MaxBubbles,MinimizeDistance,TailVisible,VerticalStudsOffset,BaseTextureId,OverlayTextureId,CameraSubject,CameraType,FieldOfView,FieldOfViewMode,Focus,HeadLocked,VRTiltAndRollEnabled,AutoSkin,BindOffset,ReferenceMeshId,ReferenceOrigin,ShrinkFactor,EnableDefaultVoice,UseAudioApi,AutoSelectGuiEnabled,GuiNavigationEnabled,SelectedObject,TouchControlsEnabled,RespawnTime,UseStrafingAnimations,CameraButtonIcon,CameraButtonPosition,CloseButtonPosition,CloseWhenScreenshotTaken,HideCoreGuiForCaptures,HidePlayerGuiForCaptures,Acceleration,Drag,EmissionDirection,FlipbookFramerate,FlipbookIncompatible,FlipbookLayout,FlipbookMode,FlipbookStartRandom,Lifetime,LightEmission,LockedToPart,Orientation,Rate,RotSpeed,Shape,ShapeInOut,ShapePartial,ShapeStyle,Speed,SpreadAngle,Squash,TimeScale,VelocityInheritance,WindAffectsDrag,ZOffset,ResetPlayerGuiOnSpawn,RtlTextSupport,ShowDevelopmentGui,VirtualCursorMode,CharacterJumpHeight,CharacterJumpPower,CharacterMaxSlopeAngle,CharacterUseJumpPower,CharacterWalkSpeed,DevComputerCameraMovementMode,DevTouchCameraMovementMode,EnableDynamicHeads,EnableMouseLockOption,LoadCharacterAppearance,LuaCharacterController,UserEmotesEnabled,HorizontalAlignment,VerticalAlignment,Decoration,GrassLength,MaterialColors,WaterColor,WaterReflectance,WaterTransparency,WaterWaveSize,WaterWaveSpeed,AsphaltName,BasaltName,BrickName,CardboardName,CarpetName,CeramicTilesName,ClayRoofTilesName,CobblestoneName,ConcreteName,CorrodedMetalName,CrackedLavaName,DiamondPlateName,FabricName,FoilName,GlacierName,GraniteName,GrassName,GroundName,IceName,LeafyGrassName,LeatherName,LimestoneName,MarbleName,MetalName,MudName,PavementName,PebbleName,PlasterName,PlasticName,RockName,RoofShinglesName,RubberName,SaltName,SandName,SandstoneName,SlateName,SmoothPlasticName,SnowName,WoodName,WoodPlanksName,HttpEnabled,ModalEnabled,MouseBehavior,MouseIcon,MouseIconEnabled,BubbleChatEnabled,LoadDefaultChat,AmbientReverb,DistanceFactor,DopplerScale,RespectFilteringEnabled,RolloffScale,VolumetricAudio,ChatVersion,CreateDefaultCommands,CreateDefaultTextChannels,CanSend}

    for _, property in ipairs(Properties) do
        if t1[property] ~= nil and t2[property] ~= nil then
            if t1[property] ~= t2[property] then
                return false
            end
        end
    end
    return true
end

function clonefunction(p1)
	assert(type(p1) == "function", "invalid argument #1 to 'clonefunction' (function expected, got " .. type(p1) .. ") ", 2)
	local A = p1
	local B = xpcall(setfenv, function(p2, p3)
		return p2, p3
	end, p1, getfenv(p1))
	if B then
		return function(...)
			return A(...)
		end
	end
	return coroutine.wrap(function(...)
		while true do
			A = coroutine.yield(A(...))
		end
	end)
end

function islclosure(func)
	assert(type(func) == "function", "invalid argument #1 to 'islclosure' (function expected, got " .. type(func) .. ") ", 2)
	local success = pcall(function()
		return setfenv(func, getfenv(func))
	end)
	return success
end
function iscclosure(func)
	assert(type(func) == "function", "invalid argument #1 to 'iscclosure' (function expected, got " .. type(func) .. ") ", 2)
    return not islclosure(func)
end

function newcclosure(p1)
	return coroutine.wrap(function(...)
		while true do
			coroutine.yield(p1(...))
		end
	end)
end

    
