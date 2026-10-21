#!/bin/bash
# Emoji picker with recent/favorites support

EMOJI_FILE="$HOME/.config/hypr/scripts/emoji-list.txt"
RECENT_FILE="$HOME/.cache/emoji-recent.txt"

# Create emoji list if it doesn't exist
if [ ! -f "$EMOJI_FILE" ]; then
    cat > "$EMOJI_FILE" << 'EOF'
😀 grinning face
😃 grinning face with big eyes
😄 grinning face with smiling eyes
😁 beaming face with smiling eyes
😆 grinning squinting face
😅 grinning face with sweat
🤣 rolling on the floor laughing
😂 face with tears of joy
🙂 slightly smiling face
🙃 upside down face
😉 winking face
😊 smiling face with smiling eyes
😇 smiling face with halo
🥰 smiling face with hearts
😍 smiling face with heart eyes
🤩 star struck
😘 face blowing a kiss
😗 kissing face
😚 kissing face with closed eyes
😙 kissing face with smiling eyes
🥲 smiling face with tear
😋 face savoring food
😛 face with tongue
😜 winking face with tongue
🤪 zany face
😝 squinting face with tongue
🤑 money mouth face
🤗 smiling face with open hands
🤭 face with hand over mouth
🤫 shushing face
🤔 thinking face
🤐 zipper mouth face
🤨 face with raised eyebrow
😐 neutral face
😑 expressionless face
😶 face without mouth
😏 smirking face
😒 unamused face
🙄 face with rolling eyes
😬 grimacing face
🤥 lying face
😌 relieved face
😔 pensive face
😪 sleepy face
🤤 drooling face
😴 sleeping face
😷 face with medical mask
🤒 face with thermometer
🤕 face with head bandage
🤢 nauseated face
🤮 face vomiting
🤧 sneezing face
🥵 hot face
🥶 cold face
😵 dizzy face
🤯 exploding head
🤠 cowboy hat face
🥳 partying face
🥸 disguised face
😎 smiling face with sunglasses
🤓 nerd face
🧐 face with monocle
😕 confused face
😟 worried face
🙁 slightly frowning face
☹️ frowning face
😮 face with open mouth
😯 hushed face
😲 astonished face
😳 flushed face
🥺 pleading face
😦 frowning face with open mouth
😧 anguished face
😨 fearful face
😰 anxious face with sweat
😥 sad but relieved face
😢 crying face
😭 loudly crying face
😱 face screaming in fear
😖 confounded face
😣 persevering face
😞 disappointed face
😓 downcast face with sweat
😩 weary face
😫 tired face
🥱 yawning face
😤 face with steam from nose
😡 enraged face
😠 angry face
🤬 face with symbols on mouth
😈 smiling face with horns
👿 angry face with horns
💀 skull
☠️ skull and crossbones
💩 pile of poo
🤡 clown face
👹 ogre
👺 goblin
👻 ghost
👽 alien
👾 alien monster
🤖 robot
😺 grinning cat
😸 grinning cat with smiling eyes
😹 cat with tears of joy
😻 smiling cat with heart eyes
😼 cat with wry smile
😽 kissing cat
🙀 weary cat
😿 crying cat
😾 pouting cat
👋 waving hand
🤚 raised back of hand
🖐️ hand with fingers splayed
✋ raised hand
🖖 vulcan salute
👌 OK hand
🤌 pinched fingers
🤏 pinching hand
✌️ victory hand
🤞 crossed fingers
🤟 love you gesture
🤘 sign of the horns
🤙 call me hand
👈 backhand index pointing left
👉 backhand index pointing right
👆 backhand index pointing up
🖕 middle finger
👇 backhand index pointing down
☝️ index pointing up
👍 thumbs up
👎 thumbs down
✊ raised fist
👊 oncoming fist
🤛 left facing fist
🤜 right facing fist
👏 clapping hands
🙌 raising hands
👐 open hands
🤲 palms up together
🤝 handshake
🙏 folded hands
✍️ writing hand
💅 nail polish
🤳 selfie
💪 flexed biceps
🦾 mechanical arm
🦿 mechanical leg
🦵 leg
🦶 foot
👂 ear
🦻 ear with hearing aid
👃 nose
🧠 brain
🫀 anatomical heart
🫁 lungs
🦷 tooth
🦴 bone
👀 eyes
👁️ eye
👅 tongue
👄 mouth
💋 kiss mark
🩸 drop of blood
❤️ red heart
🧡 orange heart
💛 yellow heart
💚 green heart
💙 blue heart
💜 purple heart
🖤 black heart
🤍 white heart
🤎 brown heart
💔 broken heart
❣️ heart exclamation
💕 two hearts
💞 revolving hearts
💓 beating heart
💗 growing heart
💖 sparkling heart
💘 heart with arrow
💝 heart with ribbon
💟 heart decoration
☮️ peace symbol
✝️ latin cross
☪️ star and crescent
🕉️ om
☸️ wheel of dharma
✡️ star of david
🔯 dotted six pointed star
🕎 menorah
☯️ yin yang
☦️ orthodox cross
🛐 place of worship
⛎ ophiuchus
♈ aries
♉ taurus
♊ gemini
♋ cancer
♌ leo
♍ virgo
♎ libra
♏ scorpio
♐ sagittarius
♑ capricorn
♒ aquarius
♓ pisces
🆔 ID button
⚛️ atom symbol
🉑 japanese acceptable button
☢️ radioactive
☣️ biohazard
📴 mobile phone off
📳 vibration mode
🆚 VS button
💮 white flower
🉐 japanese bargain button
㊙️ japanese secret button
㊗️ japanese congratulations button
🈴 japanese passing grade button
🈵 japanese no vacancy button
🈹 japanese discount button
🈲 japanese prohibited button
🅰️ A button blood type
🅱️ B button blood type
🆎 AB button blood type
🆑 CL button
🅾️ O button blood type
🆘 SOS button
❌ cross mark
⭕ hollow red circle
🛑 stop sign
⛔ no entry
📛 name badge
🚫 prohibited
💯 hundred points
💢 anger symbol
♨️ hot springs
🚷 no pedestrians
🚯 no littering
🚳 no bicycles
🚱 non potable water
🔞 no one under eighteen
📵 no mobile phones
🚭 no smoking
❗ exclamation mark
❕ white exclamation mark
❓ question mark
❔ white question mark
‼️ double exclamation mark
⁉️ exclamation question mark
🔅 dim button
🔆 bright button
〽️ part alternation mark
⚠️ warning
🚸 children crossing
🔱 trident emblem
⚜️ fleur de lis
🔰 Japanese symbol for beginner
♻️ recycling symbol
✅ check mark button
🈯 japanese reserved button
💹 chart increasing with yen
❇️ sparkle
✳️ eight spoked asterisk
❎ cross mark button
🌐 globe with meridians
💠 diamond with a dot
Ⓜ️ circled M
🌀 cyclone
💤 zzz
🏧 ATM sign
🚾 water closet
♿ wheelchair symbol
🅿️ P button
🈳 japanese vacancy button
🈂️ japanese service charge button
🛂 passport control
🛃 customs
🛄 baggage claim
🛅 left luggage
🚹 mens room
🚺 womens room
🚼 baby symbol
🚻 restroom
🚮 litter in bin sign
🎦 cinema
📶 antenna bars
🈁 japanese here button
🔣 input symbols
ℹ️ information
🔤 input latin letters
🔡 input latin lowercase
🔠 input latin uppercase
🔢 input numbers
#️⃣ keycap number sign
*️⃣ keycap asterisk
⏏️ eject button
▶️ play button
⏸️ pause button
⏯️ play or pause button
⏹️ stop button
⏺️ record button
⏭️ next track button
⏮️ last track button
⏩ fast forward button
⏪ fast reverse button
⏫ fast up button
⏬ fast down button
◀️ reverse button
🔼 upwards button
🔽 downwards button
➡️ right arrow
⬅️ left arrow
⬆️ up arrow
⬇️ down arrow
↗️ up right arrow
↘️ down right arrow
↙️ down left arrow
↖️ up left arrow
↕️ up down arrow
↔️ left right arrow
↪️ left arrow curving right
↩️ right arrow curving left
⤴️ right arrow curving up
⤵️ right arrow curving down
🔀 shuffle tracks button
🔁 repeat button
🔂 repeat single button
🔄 counterclockwise arrows button
🔃 clockwise vertical arrows
🎵 musical note
🎶 musical notes
➕ plus
➖ minus
➗ divide
✖️ multiply
♾️ infinity
💲 heavy dollar sign
💱 currency exchange
™️ trade mark
©️ copyright
®️ registered
〰️ wavy dash
➰ curly loop
➿ double curly loop
🔚 END arrow
🔙 BACK arrow
🔛 ON arrow
🔝 TOP arrow
🔜 SOON arrow
✔️ check mark
☑️ check box with check
🔘 radio button
⚪ white circle
⚫ black circle
🔴 red circle
🔵 blue circle
🟤 brown circle
🟣 purple circle
🟢 green circle
🟡 yellow circle
🟠 orange circle
🔺 red triangle pointed up
🔻 red triangle pointed down
🔸 small orange diamond
🔹 small blue diamond
🔶 large orange diamond
🔷 large blue diamond
🔳 white square button
🔲 black square button
▪️ black small square
▫️ white small square
◾ black medium small square
◽ white medium small square
◼️ black medium square
◻️ white medium square
🟥 red square
🟧 orange square
🟨 yellow square
🟩 green square
🟦 blue square
🟪 purple square
🟫 brown square
⬛ black large square
⬜ white large square
🔈 speaker low volume
🔇 muted speaker
🔉 speaker medium volume
🔊 speaker high volume
🔔 bell
🔕 bell with slash
📣 megaphone
📢 loudspeaker
💬 speech balloon
💭 thought balloon
🗯️ right anger bubble
♠️ spade suit
♣️ club suit
♥️ heart suit
♦️ diamond suit
🃏 joker
🎴 flower playing cards
🀄 mahjong red dragon
🕐 one oclock
🕑 two oclock
🕒 three oclock
🕓 four oclock
🕔 five oclock
🕕 six oclock
🕖 seven oclock
🕗 eight oclock
🕘 nine oclock
🕙 ten oclock
🕚 eleven oclock
🕛 twelve oclock
🌍 globe showing Europe Africa
🌎 globe showing Americas
🌏 globe showing Asia Australia
🌐 globe with meridians
🗺️ world map
🗾 map of Japan
🧭 compass
🏔️ snow capped mountain
⛰️ mountain
🌋 volcano
🗻 mount fuji
🏕️ camping
🏖️ beach with umbrella
🏜️ desert
🏝️ desert island
🏞️ national park
🏟️ stadium
🏛️ classical building
🏗️ building construction
🧱 brick
🪨 rock
🪵 wood
🛖 hut
🏘️ houses
🏚️ derelict house
🏠 house
🏡 house with garden
🏢 office building
🏣 Japanese post office
🏤 post office
🏥 hospital
🏦 bank
🏨 hotel
🏩 love hotel
🏪 convenience store
🏫 school
🏬 department store
🏭 factory
🏯 Japanese castle
🏰 castle
💒 wedding
🗼 Tokyo tower
🗽 Statue of Liberty
⛪ church
🕌 mosque
🛕 hindu temple
🕍 synagogue
⛩️ shinto shrine
🕋 kaaba
⛲ fountain
⛺ tent
🌁 foggy
🌃 night with stars
🏙️ cityscape
🌄 sunrise over mountains
🌅 sunrise
🌆 cityscape at dusk
🌇 sunset
🌉 bridge at night
♨️ hot springs
🎠 carousel horse
🎡 ferris wheel
🎢 roller coaster
💈 barber pole
🎪 circus tent
🚂 locomotive
🚃 railway car
🚄 high speed train
🚅 bullet train
🚆 train
🚇 metro
🚈 light rail
🚉 station
🚊 tram
🚝 monorail
🚞 mountain railway
🚋 tram car
🚌 bus
🚍 oncoming bus
🚎 trolleybus
🚐 minibus
🚑 ambulance
🚒 fire engine
🚓 police car
🚔 oncoming police car
🚕 taxi
🚖 oncoming taxi
🚗 automobile
🚘 oncoming automobile
🚙 sport utility vehicle
🛻 pickup truck
🚚 delivery truck
🚛 articulated lorry
🚜 tractor
🏎️ racing car
🏍️ motorcycle
🛵 motor scooter
🦽 manual wheelchair
🦼 motorized wheelchair
🛺 auto rickshaw
🚲 bicycle
🛴 kick scooter
🛹 skateboard
🛼 roller skate
🚏 bus stop
🛣️ motorway
🛤️ railway track
🛢️ oil drum
⛽ fuel pump
🚨 police car light
🚥 horizontal traffic light
🚦 vertical traffic light
🛑 stop sign
🚧 construction
⚓ anchor
⛵ sailboat
🛶 canoe
🚤 speedboat
🛳️ passenger ship
⛴️ ferry
🛥️ motor boat
🚢 ship
✈️ airplane
🛩️ small airplane
🛫 airplane departure
🛬 airplane arrival
🪂 parachute
💺 seat
🚁 helicopter
🚟 suspension railway
🚠 mountain cableway
🚡 aerial tramway
🛰️ satellite
🚀 rocket
🛸 flying saucer
🛎️ bellhop bell
🧳 luggage
⌛ hourglass done
⏳ hourglass not done
⌚ watch
⏰ alarm clock
⏱️ stopwatch
⏲️ timer clock
🕰️ mantelpiece clock
⏲️ timer clock
📅 calendar
📆 tear off calendar
🗓️ spiral calendar
📇 card index
📈 chart increasing
📉 chart decreasing
📊 bar chart
📋 clipboard
📌 pushpin
📍 round pushpin
📎 paperclip
🖇️ linked paperclips
📏 straight ruler
📐 triangular ruler
✂️ scissors
🗃️ card file box
🗄️ file cabinet
🗑️ wastebasket
🔒 locked
🔓 unlocked
🔏 locked with pen
🔐 locked with key
🔑 key
🗝️ old key
🔨 hammer
🪓 axe
⛏️ pick
⚒️ hammer and pick
🛠️ hammer and wrench
🗡️ dagger
⚔️ crossed swords
🔫 water pistol
🪃 boomerang
🏹 bow and arrow
🛡️ shield
🪚 carpentry saw
🔧 wrench
🪛 screwdriver
🔩 nut and bolt
⚙️ gear
🗜️ clamp
⚖️ balance scale
🦯 white cane
🔗 link
⛓️ chains
🪝 hook
🧰 toolbox
🧲 magnet
🪜 ladder
⚗️ alembic
🧪 test tube
🧫 petri dish
🧬 dna
🔬 microscope
🔭 telescope
📡 satellite antenna
💉 syringe
🩸 drop of blood
💊 pill
🩹 adhesive bandage
🩺 stethoscope
🚪 door
🛗 elevator
🪞 mirror
🪟 window
🛏️ bed
🛋️ couch and lamp
🪑 chair
🚽 toilet
🪠 plunger
🚿 shower
🛁 bathtub
🪤 mouse trap
🪒 razor
🧴 lotion bottle
🧷 safety pin
🧹 broom
🧺 basket
🧻 roll of paper
🪣 bucket
🧼 soap
🪥 toothbrush
🧽 sponge
🧯 fire extinguisher
🛒 shopping cart
🚬 cigarette
⚰️ coffin
🪦 headstone
⚱️ funeral urn
🗿 moai
🪧 placard
🔮 crystal ball
EOF
fi

# Get recent emojis
get_recent() {
    [ -f "$RECENT_FILE" ] && head -n 10 "$RECENT_FILE" || echo ""
}

# Add to recent
add_recent() {
    local emoji="$1"
    touch "$RECENT_FILE"
    # Remove if exists, add to top
    grep -v "^$emoji " "$RECENT_FILE" > "${RECENT_FILE}.tmp" 2>/dev/null || true
    echo "$emoji" > "$RECENT_FILE"
    head -n 9 "${RECENT_FILE}.tmp" >> "$RECENT_FILE" 2>/dev/null || true
    rm -f "${RECENT_FILE}.tmp"
}

# Build menu
RECENT=$(get_recent)
if [ -n "$RECENT" ]; then
    MENU="━━━ Recent ━━━\n$RECENT\n━━━ All Emojis ━━━\n$(cat "$EMOJI_FILE")"
else
    MENU=$(cat "$EMOJI_FILE")
fi

# Show picker
SELECTED=$(echo -e "$MENU" | rofi -dmenu -p "Emoji" -theme ~/.config/rofi/styles/simple.rasi)

if [ -n "$SELECTED" ]; then
    EMOJI=$(echo "$SELECTED" | awk '{print $1}')
    echo -n "$EMOJI" | wl-copy
    add_recent "$SELECTED"
    notify-send "Emoji" "Copied: $EMOJI"
fi
