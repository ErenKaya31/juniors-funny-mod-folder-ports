local bounceAnimState = 0;
local bounceMultiplier = 1;
local yBullshit = 1;

function onCreate()
    makeAnimatedLuaSprite('redTunnel', 'main/wireframe/redTunnel', -1000, -1000)
    addAnimationByPrefix('redTunnel', 'idle', 'redtunnel idle0', 24, true)
    objectPlayAnimation('redTunnel', 'idle', true)
    setProperty('redTunnel.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))
    --setGraphicSize('redTunnel', math.floor(getProperty('redTunnel.width') * 1.15), math.floor(getProperty('redTunnel.height') * 1.15));
    setProperty('redTunnel.scale.x', 4)--getProperty('redTunnel.width') * 1.15)
    setProperty('redTunnel.scale.y', 3.25)--getProperty('redTunnel.height') * 1.15)
    updateHitbox('redTunnel')
    addLuaSprite('redTunnel', false)

    makeAnimatedLuaSprite('daveFuckingDies', 'main/wireframe/pissBoy', 0, 1500)
    addAnimationByPrefix('daveFuckingDies', 'idle', 'IDLE', 24, false)
    addAnimationByPrefix('daveFuckingDies', 'bounceLeft', 'EDGE', 24, false)
    addAnimationByPrefix('daveFuckingDies', 'bounceRight', 'EDGE', 24, false, true)
    objectPlayAnimation('daveFuckingDies', 'idle', true)
    setProperty('daveFuckingDies.antialiasing', false)
    setProperty('daveFuckingDies.visible', false)
    updateHitbox('daveFuckingDies')
    if not lowQuality then
        addLuaSprite('daveFuckingDies', false)
    end
end

function onCreatePost()
    changeNoteSkin(false, 'NOTE_assets_3D')
end

function onUpdate(elapsed)
    if getProperty('dad.curCharacter') == 'badai' then
        --setProperty('dad.angle', getProperty('dad.angle') +elapsed * 50);
    end

    if getProperty('dad.curCharacter') == 'badai' then
        --setProperty('dad.angle', getProperty('dad.angle') +elapsed * 50);
        setProperty('dad.y', getProperty('dad.y') +(math.sin(elapsed) * 0.6));
    end

    if getProperty('dad.curCharacter') == 'badai' then
        --setProperty('dad.angle', getProperty('dad.angle') +math.sin(elapsed) * 15);
        setProperty('dad.x', getProperty('dad.x') +math.sin(elapsed) * 0.6);
        setProperty('dad.y', getProperty('dad.y') +(math.sin(elapsed) * 0.6));
    end

    local yStuff = bounceMultiplier * yBullshit;

    setProperty('daveFuckingDies.angle', elapsed * 20);
    setProperty('daveFuckingDies.x', 1 * bounceMultiplier);
    setProperty('daveFuckingDies.y', 1 * yStuff);

    if getProperty('daveFuckingDies.x') >= (getProperty('redTunnel.width') - 1000) or getProperty('daveFuckingDies.y') >= (getProperty('redTunnel.height') - 1000) then
        bounceAnimState = 1;
        bounceMultiplier = getRandomFloat(-0.75, -1.15);
        yBullshit = getRandomFloat(0.95, 1.05);
        danceDave();
    end
    if getProperty('daveFuckingDies.x') <= (getProperty('redTunnel.x') + 100) or getProperty('daveFuckingDies.y') <= (getProperty('redTunnel.y') + 100) then
        bounceAnimState = 2;
        bounceMultiplier = getRandomFloat(0.75, 1.15);
        yBullshit = getRandomFloat(0.95, 1.05);
        danceDave();
    end

    if getProperty('daveFuckingDies.x') >= (getProperty('redTunnel.width') - 1150) or getProperty('daveFuckingDies.y') >= (getProperty('redTunnel.height') - 1150) then
        bounceAnimState = 1;
        runTimer('daveIdle', 1.25)
    end
    if getProperty('daveFuckingDies.x') <= (getProperty('redTunnel.x') + 250) or getProperty('daveFuckingDies.y') <= (getProperty('redTunnel.y') + 250) then
        bounceAnimState = 2;
        runTimer('daveIdle', 1.25)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'daveIdle' then
        bounceAnimState = 0;
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
		objectPlayAnimation('daveFuckingDies', 'idle');
	end
end

function danceDave()
    if bounceAnimState == 0 then
        objectPlayAnimation('daveFuckingDies', 'idle', true);
    end
    if bounceAnimState == 1 then
        objectPlayAnimation('daveFuckingDies', 'bounceLeft');
    end
    if bounceAnimState == 2 then
        objectPlayAnimation('daveFuckingDies', 'bounceRight');
    end
end

function changeNoteSkin(player, skin)
	if player == true then
		for i = 0, 4, 1 do
			setPropertyFromGroup('playerStrums', i, 'texture', skin)
		end
	end
    if not player then
		for i = 0, 4, 1 do
			setPropertyFromGroup('opponentStrums', i, 'texture', skin)
		end
	end

    for i = 0, getProperty('notes.length') -1 do
        if getPropertyFromGroup('notes', i, 'mustPress') == player then --only "player" side
            setPropertyFromGroup('notes', i, 'texture', skin)
        end
    end

    for i = 0, getProperty('unspawnNotes.length') -1 do
        if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == player then --only "player" side
            setPropertyFromGroup('unspawnNotes', i, 'texture', skin)
        end
    end
end