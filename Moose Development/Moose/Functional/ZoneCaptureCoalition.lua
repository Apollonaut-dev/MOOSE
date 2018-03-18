--- **Functional** -- (WIP R2.3) Models the process to capture a Zone for a Coalition, which is guarded by another Coalition.
--
-- ====
-- 
-- ![Banner Image](..\Presentations\ZONE_CAPTURE_COALITION\Dia1.JPG)
-- 
-- ===
-- 
-- ### Contributions: **Millertime**: Concept
-- ### Author: **Sven Van de Velde (FlightControl)**
-- 
-- ====
-- 
-- @module ZoneCaptureCoalition

do -- ZONE_CAPTURE_COALITION

  --- @type ZONE_CAPTURE_COALITION
  -- @extends Functional.ZoneGoalCoalition#ZONE_GOAL_COALITION


  --- # ZONE\_CAPTURE\_COALITION class, extends @{ZoneGoalCoalition#ZONE_GOAL_COALITION}
  -- 
  -- Models the process to capture a Zone for a Coalition, which is guarded by another Coalition.
  -- This is a powerful concept that allows to create very dynamic missions based on the different state transitions of various zones.
  -- 
  -- ---
  --
  -- ![Banner Image](..\Presentations\ZONE_CAPTURE_COALITION\Dia1.JPG)
  --
  -- ---
  -- 
  -- # 0. Player Experience
  -- 
  -- ![States](..\Presentations\ZONE_CAPTURE_COALITION\Dia3.JPG)
  --  
  -- The Zone is initially **Guarded** by the __owning coalition__, which is the coalition that initially occupies the zone with units of its coalition.
  -- Once units of an other coalition are entering the Zone, the state will change to **Attacked**. As long as these units remain in the zone, the state keeps set to Attacked.
  -- When all units are destroyed in the Zone, the state will change to **Empty**, which expresses that the Zone is empty, and can be captured.
  -- When units of the other coalition are in the Zone, and no other units of the owning coalition is in the Zone, the Zone is captured, and its state will change to **Captured**.
  -- 
  -- The above models the possible state transitions between the Guarded, Attacked, Empty and Captured states.
  --
  -- ## 1. ZONE\_CAPTURE\_COALITION constructor
  --   
  --   * @{#ZONE_CAPTURE_COALITION.New}(): Creates a new ZONE\_CAPTURE\_COALITION object.
  --   
  -- In order to use ZONE\_CAPTURE\_COALITION, you need to:
  -- 
  --   - Create a @{Zone} object from one of the ZONE\_ classes. Note that ZONE\_POLYGON\_ classes are not yet functional. The only functional ZONE\_ classses are those derived from a ZONE\_RADIUS.
  -- 
  -- ![New](..\Presentations\ZONE_CAPTURE_COALITION\Dia5.JPG)
  -- 
  -- Ensure that during the life cycle of the ZONE\_CAPTURE\_COALITION object, the object keeps alive.
  -- It is best to declare the object globally within your script.
  -- 
  -- ## 2. ZONE\_CAPTURE\_COALITION is a finite state machine (FSM).
  -- 
  -- ![States](..\Presentations\ZONE_CAPTURE_COALITION\Dia4.JPG)
  -- 
  -- ### 2.1 ZONE\_CAPTURE\_COALITION States
  -- 
  --   * **Captured**: The Zone has been captured by an other coalition.
  --   * **Attacked**: The Zone is currently intruded by an other coalition. There are units of the owning coalition and an other coalition in the Zone.
  --   * **Guarded**: The Zone is guarded by the owning coalition. There is no other unit of an other coalition in the Zone.
  --   * **Empty**: The Zone is empty. There is not valid unit in the Zone.
  --   
  -- ### 2.2 ZONE\_CAPTURE\_COALITION Events
  -- 
  --   * **Capture**: The Zone has been captured by an other coalition.
  --   * **Attack**: The Zone is currently intruded by an other coalition. There are units of the owning coalition and an other coalition in the Zone.
  --   * **Guard**: The Zone is guarded by the owning coalition. There is no other unit of an other coalition in the Zone.
  --   * **Empty**: The Zone is empty. There is not valid unit in the Zone.
  -- 
  -- ## 3. "Script It"
  -- 
  -- ZONE\_CAPTURE\_COALITION allows to take action on the various state transitions and add your custom code and logic.
  -- 
  -- ### 3.1. Take action using state- and event handlers.
  -- 
  -- ![States](..\Presentations\ZONE_CAPTURE_COALITION\Dia6.JPG)
  -- 
  -- The most important to understand is how states and events can be tailored.
  -- Carefully study the diagram and the explanations.
  -- 
  -- **State Handlers** capture the moment:
  -- 
  --   - On Leave from the old state. Return false to cancel the transition.
  --   - On Enter to the new state.
  -- 
  -- **Event Handlers** capture the moment:
  -- 
  --   - On Before the event is triggered. Return false to cancel the transition.
  --   - On After the event is triggered.
  -- 
  -- 
  -- 
  -- ![States](..\Presentations\ZONE_CAPTURE_COALITION\Dia7.JPG)
  -- 
  -- Each handler can receive optionally 3 parameters:
  -- 
  --   - **From**: A string containing the From State.
  --   - **Event**: A string containing the Event.
  --   - **To**: A string containing the To State.
  --   
  -- The mission designer can use these values to alter the logic.
  -- For example:
  -- 
  --     --- @param Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION self
  --     function ZoneCaptureCoalition:OnEnterGuarded( From, Event, To )
  --       if From ~= "Empty" then
  --         -- Display a message
  --       end
  --     end
  -- 
  -- This code checks that when the __Guarded__ state has been reached, that if the **From** state was __Empty__, then display a message.
  -- 
  -- ### 3.2. Example Event Handler.
  -- 
  --     --- @param Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION self
  --     function ZoneCaptureCoalition:OnEnterGuarded( From, Event, To )
  --       if From ~= To then
  --         local Coalition = self:GetCoalition()
  --         self:E( { Coalition = Coalition } )
  --         if Coalition == coalition.side.BLUE then
  --           ZoneCaptureCoalition:Smoke( SMOKECOLOR.Blue )
  --           US_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --           RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --         else
  --           ZoneCaptureCoalition:Smoke( SMOKECOLOR.Red )
  --           RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --           US_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --         end
  --       end
  --     end
  -- 
  -- ## 4. Full Example
  -- 
  -- The following annotated code shows a real example of how ZONE\_CAPTURE\_COALITION can be applied.
  -- 
  -- The concept is simple.
  -- 
  -- The USA (US), blue coalition, needs to capture the Russian (RU), red coalition, zone, which is near groom lake.
  -- 
  -- A capture zone has been setup that guards the presence of the troops.
  -- Troops are guarded by red forces. Blue is required to destroy the red forces and capture the zones.
  -- 
  -- At first, we setup the Command Centers
  -- 
  --      do
  --        
  --        RU_CC = COMMANDCENTER:New( GROUP:FindByName( "REDHQ" ), "Russia HQ" )
  --        US_CC = COMMANDCENTER:New( GROUP:FindByName( "BLUEHQ" ), "USA HQ" )
  --      
  --      end
  --      
  -- Next, we define the mission, and add some scoring to it.
  --      
  --      do -- Missions
  --        
  --        US_Mission_EchoBay = MISSION:New( US_CC, "Echo Bay", "Primary",
  --          "Welcome trainee. The airport Groom Lake in Echo Bay needs to be captured.\n" ..
  --          "There are five random capture zones located at the airbase.\n" ..
  --          "Move to one of the capture zones, destroy the fuel tanks in the capture zone, " ..
  --          "and occupy each capture zone with a platoon.\n " .. 
  --          "Your orders are to hold position until all capture zones are taken.\n" ..
  --          "Use the map (F10) for a clear indication of the location of each capture zone.\n" ..
  --          "Note that heavy resistance can be expected at the airbase!\n" ..
  --          "Mission 'Echo Bay' is complete when all five capture zones are taken, and held for at least 5 minutes!"
  --          , coalition.side.RED)
  --          
  --        US_Score = SCORING:New( "CAZ-001 - Capture Zone" )
  --          
  --        US_Mission_EchoBay:AddScoring( US_Score )
  --        
  --        US_Mission_EchoBay:Start()
  --      
  --      end
  --      
  --      
  -- Now the real work starts.
  -- We define a **CaptureZone** object, which is a ZONE object.
  -- Within the mission, a trigger zone is created with the name __CaptureZone__, with the defined radius within the mission editor.
  -- 
  --      CaptureZone = ZONE:New( "CaptureZone" )
  -- 
  -- Next, we define the **ZoneCaptureCoalition** object, as explained above.
  --      
  --      ZoneCaptureCoalition = ZONE_CAPTURE_COALITION:New( CaptureZone, coalition.side.RED ) 
  --      
  -- Of course, we want to let the **ZoneCaptureCoalition** object do something when the state transitions.
  -- Do accomodate this, it is very simple, as explained above.
  -- We use **Event Handlers** to tailor the logic.
  -- 
  -- Here we place an Event Handler at the Guarded event. So when the **Guarded** event is triggered, then this method is called!
  -- With the variables **From**, **Event**, **To**. Each of these variables containing a string.
  -- 
  -- We check if the previous state wasn't Guarded also.
  -- If not, we retrieve the owning Coalition of the **ZoneCaptureCoalition**, using `self:GetCoalition()`.
  -- So **Coalition** will contain the current owning coalition of the zone.
  -- 
  -- Depending on the zone ownership, different messages are sent.
  -- Note the methods `ZoneCaptureCoalition:GetZoneName()`.
  --      
  --      --- @param Functional.ZoneCaptureCoalition#ZONE_CAPTURE_COALITION self
  --      function ZoneCaptureCoalition:OnEnterGuarded( From, Event, To )
  --        if From ~= To then
  --          local Coalition = self:GetCoalition()
  --          self:E( { Coalition = Coalition } )
  --          if Coalition == coalition.side.BLUE then
  --            ZoneCaptureCoalition:Smoke( SMOKECOLOR.Blue )
  --            US_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --            RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --          else
  --            ZoneCaptureCoalition:Smoke( SMOKECOLOR.Red )
  --            RU_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --            US_CC:MessageTypeToCoalition( string.format( "%s is under protection of Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --          end
  --        end
  --      end
  -- 
  -- As you can see, not a rocket science.
  -- Next is the Event Handler when the **Empty** state transition is triggered.
  -- Now we smoke the ZoneCaptureCoalition with a green color, using `self:Smoke( SMOKECOLOR.Green )`.
  --      
  --      --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
  --      function ZoneCaptureCoalition:OnEnterEmpty()
  --        self:Smoke( SMOKECOLOR.Green )
  --        US_CC:MessageTypeToCoalition( string.format( "%s is unprotected, and can be captured!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --        RU_CC:MessageTypeToCoalition( string.format( "%s is unprotected, and can be captured!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --      end
  -- 
  -- The next Event Handlers speak for itself.
  -- When the zone is Attacked, we smoke the zone white and send some messages to each coalition.     
  --      
  --      --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
  --      function ZoneCaptureCoalition:OnEnterAttacked()
  --        ZoneCaptureCoalition:Smoke( SMOKECOLOR.White )
  --        local Coalition = self:GetCoalition()
  --        self:E({Coalition = Coalition})
  --        if Coalition == coalition.side.BLUE then
  --          US_CC:MessageTypeToCoalition( string.format( "%s is under attack by Russia", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --          RU_CC:MessageTypeToCoalition( string.format( "We are attacking %s", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --        else
  --          RU_CC:MessageTypeToCoalition( string.format( "%s is under attack by the USA", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --          US_CC:MessageTypeToCoalition( string.format( "We are attacking %s", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --        end
  --      end
  -- 
  -- When the zone is Captured, we send some victory or loss messages to the correct coalition.
  -- And we add some score.
  -- 
  --      --- @param Functional.Protect#ZONE_CAPTURE_COALITION self
  --      function ZoneCaptureCoalition:OnEnterCaptured()
  --        local Coalition = self:GetCoalition()
  --        self:E({Coalition = Coalition})
  --        if Coalition == coalition.side.BLUE then
  --          RU_CC:MessageTypeToCoalition( string.format( "%s is captured by the USA, we lost it!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --          US_CC:MessageTypeToCoalition( string.format( "We captured %s, Excellent job!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --        else
  --          US_CC:MessageTypeToCoalition( string.format( "%s is captured by Russia, we lost it!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --          RU_CC:MessageTypeToCoalition( string.format( "We captured %s, Excellent job!", ZoneCaptureCoalition:GetZoneName() ), MESSAGE.Type.Information )
  --        end
  --        
  --        self:AddScore( "Captured", "Zone captured: Extra points granted.", 200 )    
  --        
  --        self:__Guard( 30 )
  --      end
  -- 
  -- And this call is the most important of all!
  -- Here we ensure that we **Guard** the **ZoneCaptureCoalition**!!
  -- 
  -- If we don't call this method, the whole guarding process won't be started!!!
  --        
  --      ZoneCaptureCoalition:__Guard( 1 )
  --      
  --      
  -- 
  -- @field #ZONE_CAPTURE_COALITION
  ZONE_CAPTURE_COALITION = {
    ClassName = "ZONE_CAPTURE_COALITION",
  }
  
  --- @field #table ZONE_CAPTURE_COALITION.States
  ZONE_CAPTURE_COALITION.States = {}
  
  --- ZONE_CAPTURE_COALITION Constructor.
  -- @param #ZONE_CAPTURE_COALITION self
  -- @param Core.Zone#ZONE Zone A @{Zone} object with the goal to be achieved.
  -- @param DCSCoalition.DCSCoalition#coalition Coalition The initial coalition owning the zone.
  -- @return #ZONE_CAPTURE_COALITION
  -- @usage
  -- 
  --  AttackZone = ZONE:New( "AttackZone" )
  --
  --  ZoneCaptureCoalition = ZONE_CAPTURE_COALITION:New( AttackZone, coalition.side.RED ) -- Create a new ZONE_CAPTURE_COALITION object of zone AttackZone with ownership RED coalition.
  --  ZoneCaptureCoalition:__Guard( 1 ) -- Start the Guarding of the AttackZone.
  --  
  function ZONE_CAPTURE_COALITION:New( Zone, Coalition )
  
    local self = BASE:Inherit( self, ZONE_GOAL_COALITION:New( Zone, Coalition ) ) -- #ZONE_CAPTURE_COALITION

    self:F( { Zone = Zone, Coalition  = Coalition } )

    do 
    
      --- Captured State Handler OnLeave for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnLeaveCaptured
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
      -- @return #boolean
  
      --- Captured State Handler OnEnter for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnEnterCaptured
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
  
    end
  
  
    do 
    
      --- Attacked State Handler OnLeave for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnLeaveAttacked
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
      -- @return #boolean
  
      --- Attacked State Handler OnEnter for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnEnterAttacked
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
  
    end

    do 
    
      --- Guarded State Handler OnLeave for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnLeaveGuarded
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
      -- @return #boolean
  
      --- Guarded State Handler OnEnter for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnEnterGuarded
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
  
    end
  

    do 
    
      --- Empty State Handler OnLeave for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnLeaveEmpty
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
      -- @return #boolean
  
      --- Empty State Handler OnEnter for ZONE\_CAPTURE\_COALITION
      -- @function [parent=#ZONE_CAPTURE_COALITION] OnEnterEmpty
      -- @param #ZONE_CAPTURE_COALITION self
      -- @param #string From
      -- @param #string Event
      -- @param #string To
  
    end
  
    self:AddTransition( "*", "Guard", "Guarded" )
    
    --- Guard Handler OnBefore for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnBeforeGuard
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    -- @return #boolean
    
    --- Guard Handler OnAfter for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnAfterGuard
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    
    --- Guard Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] Guard
    -- @param #ZONE_CAPTURE_COALITION self
    
    --- Guard Asynchronous Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] __Guard
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #number Delay
    
    self:AddTransition( "*", "Empty", "Empty" )
    
    --- Empty Handler OnBefore for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnBeforeEmpty
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    -- @return #boolean
    
    --- Empty Handler OnAfter for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnAfterEmpty
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    
    --- Empty Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] Empty
    -- @param #ZONE_CAPTURE_COALITION self
    
    --- Empty Asynchronous Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] __Empty
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #number Delay
    
    
    self:AddTransition( {  "Guarded", "Empty" }, "Attack", "Attacked" )
  
    --- Attack Handler OnBefore for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnBeforeAttack
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    -- @return #boolean
    
    --- Attack Handler OnAfter for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnAfterAttack
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    
    --- Attack Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] Attack
    -- @param #ZONE_CAPTURE_COALITION self
    
    --- Attack Asynchronous Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] __Attack
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #number Delay
    
    self:AddTransition( { "Guarded", "Attacked", "Empty" }, "Capture", "Captured" )
   
    --- Capture Handler OnBefore for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnBeforeCapture
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    -- @return #boolean
    
    --- Capture Handler OnAfter for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] OnAfterCapture
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #string From
    -- @param #string Event
    -- @param #string To
    
    --- Capture Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] Capture
    -- @param #ZONE_CAPTURE_COALITION self
    
    --- Capture Asynchronous Trigger for ZONE\_CAPTURE\_COALITION
    -- @function [parent=#ZONE_CAPTURE_COALITION] __Capture
    -- @param #ZONE_CAPTURE_COALITION self
    -- @param #number Delay

    if not self.ScheduleStatusZone then
      self.ScheduleStatusZone = self:ScheduleRepeat( 15, 15, 0.1, nil, self.StatusZone, self )
    end

    return self
  end
  

  --- @param #ZONE_CAPTURE_COALITION self
  function ZONE_CAPTURE_COALITION:onenterCaptured()
  
    self:GetParent( self, ZONE_CAPTURE_COALITION ).onenterCaptured( self )
    
    self.Goal:Achieved()
  end


  function ZONE_CAPTURE_COALITION:IsGuarded()
  
    local IsGuarded = self.Zone:IsAllInZoneOfCoalition( self.Coalition )
    self:F( { IsGuarded = IsGuarded } )
    return IsGuarded
  end


  function ZONE_CAPTURE_COALITION:IsEmpty()
  
    local IsEmpty = self.Zone:IsNoneInZone()
    self:F( { IsEmpty = IsEmpty } )
    return IsEmpty
  end


  function ZONE_CAPTURE_COALITION:IsCaptured()
  
    local IsCaptured = self.Zone:IsAllInZoneOfOtherCoalition( self.Coalition )
    self:F( { IsCaptured = IsCaptured } )
    return IsCaptured
  end
  
  
  function ZONE_CAPTURE_COALITION:IsAttacked()
  
    local IsAttacked = self.Zone:IsSomeInZoneOfCoalition( self.Coalition )
    self:F( { IsAttacked = IsAttacked } )
    return IsAttacked
  end
  
  

  --- Mark.
  -- @param #ZONE_CAPTURE_COALITION self
  function ZONE_CAPTURE_COALITION:Mark()
  
    local Coord = self.Zone:GetCoordinate()
    local ZoneName = self:GetZoneName()
    local State = self:GetState()
    
    if self.MarkRed and self.MarkBlue then
      self:F( { MarkRed = self.MarkRed, MarkBlue = self.MarkBlue } )
      Coord:RemoveMark( self.MarkRed )
      Coord:RemoveMark( self.MarkBlue )
    end
    
    if self.Coalition == coalition.side.BLUE then
      self.MarkBlue = Coord:MarkToCoalitionBlue( "Coalition: Blue\nGuard Zone: " .. ZoneName .. "\nStatus: " .. State )  
      self.MarkRed = Coord:MarkToCoalitionRed( "Coalition: Blue\nCapture Zone: " .. ZoneName .. "\nStatus: " .. State )
    else
      self.MarkRed = Coord:MarkToCoalitionRed( "Coalition: Red\nGuard Zone: " .. ZoneName .. "\nStatus: " .. State )  
      self.MarkBlue = Coord:MarkToCoalitionBlue( "Coalition: Red\nCapture Zone: " .. ZoneName .. "\nStatus: " .. State )  
    end
  end

  --- Bound.
  -- @param #ZONE_CAPTURE_COALITION self
  function ZONE_CAPTURE_COALITION:onenterGuarded()
  
    --self:GetParent( self ):onenterGuarded()
  
    if self.Coalition == coalition.side.BLUE then
      --elf.ProtectZone:BoundZone( 12, country.id.USA )
    else
      --self.ProtectZone:BoundZone( 12, country.id.RUSSIA )
    end
    
    self:Mark()
    
  end
  
  function ZONE_CAPTURE_COALITION:onenterCaptured()
  
    --self:GetParent( self ):onenterCaptured()

    local NewCoalition = self.Zone:GetScannedCoalition()
    self:F( { NewCoalition = NewCoalition } )
    self:SetCoalition( NewCoalition )
  
    self:Mark()
  end
  
  
  function ZONE_CAPTURE_COALITION:onenterEmpty()

    --self:GetParent( self ):onenterEmpty()
  
    self:Mark()
  end
  
  
  function ZONE_CAPTURE_COALITION:onenterAttacked()
  
    --self:GetParent( self ):onenterAttacked()
  
    self:Mark()
  end


  --- When started, check the Coalition status.
  -- @param #ZONE_CAPTURE_COALITION self
  function ZONE_CAPTURE_COALITION:onafterGuard()
  
    --self:F({BASE:GetParent( self )})
    --BASE:GetParent( self ).onafterGuard( self )
  
    if not self.SmokeScheduler then
      self.SmokeScheduler = self:ScheduleRepeat( 1, 1, 0.1, nil, self.StatusSmoke, self )
    end
  end


  function ZONE_CAPTURE_COALITION:IsCaptured()
  
    local IsCaptured = self.Zone:IsAllInZoneOfOtherCoalition( self.Coalition )
    self:F( { IsCaptured = IsCaptured } )
    return IsCaptured
  end
  
  
  function ZONE_CAPTURE_COALITION:IsAttacked()
  
    local IsAttacked = self.Zone:IsSomeInZoneOfCoalition( self.Coalition )
    self:F( { IsAttacked = IsAttacked } )
    return IsAttacked
  end
  

  --- Check status Coalition ownership.
  -- @param #ZONE_CAPTURE_COALITION self
  function ZONE_CAPTURE_COALITION:StatusZone()
  
    local State = self:GetState()
    self:F( { State = self:GetState() } )
  
    self:GetParent( self, ZONE_CAPTURE_COALITION ).StatusZone( self )
    
    if State ~= "Guarded" and self:IsGuarded() then
      self:Guard()
    end
    
    if State ~= "Empty" and self:IsEmpty() then  
      self:Empty()
    end

    if State ~= "Attacked" and self:IsAttacked() then
      self:Attack()
    end
    
    if State ~= "Captured" and self:IsCaptured() then  
      self:Capture()
    end
    
  end
  
end

