globals [
  num-turtles
  overall-avg-gain
  s1-avg-gain
  s2-avg-gain
  equality
  sum-time-gains
  sum-tics-alive
  sustainability
]

patches-own [
  is-tree
  has-fruit
  is-wall
]

turtles-own [
  strategy
  gain

  freeze-time
  eat-blocked-time

  eat-vision
  eat-threshold

  shoot-vision
  shoot-threshold
  shoot-accuracy
  shoot-chance
]

__includes ["agents.nls" "metrics.nls" "actions.nls"]

to setup
  clear-all
  ;; make some trees
  set num-turtles num-turtles-s1 + num-turtles-s2
  ask patches [init-trees]
  init-turtles
  set sum-time-gains 0
  set sum-tics-alive 0
  render
  reset-ticks
end

to init-trees
  ifelse (random-float 100) < density [
    set is-tree true
    set has-fruit true
  ][
    set is-tree false
    set has-fruit false
  ]
end

to init-turtles
  create-turtles num-turtles-s1 [
    set shape "robot"
    set color yellow
    set strategy 1
    spawn
  ]

  create-turtles num-turtles-s2 [
    set shape "robot"
    set color red
    set strategy 2
    spawn
  ]
  update-turtle-constants
end

to update-turtle-constants
  ask turtles with [strategy = 1] [
    set eat-vision eat-vision-s1
    set eat-threshold eat-threshold-s1

    set shoot-vision shoot-vision-s1
    set shoot-threshold shoot-threshold-s1
    set shoot-accuracy shoot-accuracy-s1
    set shoot-chance shoot-chance-s1
  ]

  ask turtles with [strategy = 2] [
    set eat-vision eat-vision-s2
    set eat-threshold eat-threshold-s2

    set shoot-vision shoot-vision-s2
    set shoot-threshold shoot-threshold-s2
    set shoot-accuracy shoot-accuracy-s2
    set shoot-chance shoot-chance-s2
  ]

end

to go
  ask links [die]
  if mouse-down? [
    ask patch (round mouse-xcor) (round mouse-ycor)
    [ set has-fruit false ]
  ]

  if always-update-turtle-constants [ update-turtle-constants ]

  set sum-tics-alive sum-tics-alive + count turtles with [freeze-time <= 0]
  ask turtles with [freeze-time <= 0] [act]

  ask turtles [unfreeze]
  regrow
  if render? [render]
  if ticks > 0 [calculate-metrics]
  tick
end

to render
  ask patches [
    if is-tree [
      ifelse has-fruit
      [set pcolor green]
      [set pcolor 52]
    ]
  ]
end

to regrow
  ask patches with [is-tree and not has-fruit] [
    let fertility count neighbors with [has-fruit]
    if (random-float 1) < 1 - ((1 - spread-rate / 1000) ^ fertility)
    [ set has-fruit true ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
375
30
1443
699
-1
-1
20.0
1
10
1
1
1
0
0
0
1
0
52
0
32
1
1
1
ticks
30.0

SLIDER
15
105
187
138
density
density
0
100
30.0
1
1
%
HORIZONTAL

SLIDER
191
105
363
138
spread-rate
spread-rate
0
100
10.0
1
1
???
HORIZONTAL

BUTTON
121
36
188
69
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
192
36
255
69
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
15
185
187
218
num-turtles-s1
num-turtles-s1
0
10
5.0
1
1
NIL
HORIZONTAL

PLOT
1455
10
1820
185
efficiency
NIL
NIL
0.0
1000.0
0.0
0.2
true
false
"" ""
PENS
"all" 1.0 0 -16777216 true "" "if ticks > 0 [plot overall-avg-gain]"
"strategy 1" 1.0 0 -1184463 true "" "if ticks > 0 [plot s1-avg-gain]"
"pen-2" 1.0 0 -2674135 true "" "if ticks > 0 [plot s2-avg-gain]"

SLIDER
191
185
363
218
num-turtles-s2
num-turtles-s2
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
15
264
187
297
eat-threshold-s1
eat-threshold-s1
0
8
4.0
1
1
NIL
HORIZONTAL

SLIDER
15
327
187
360
shoot-threshold-s1
shoot-threshold-s1
0
36
40.0
1
1
NIL
HORIZONTAL

SLIDER
191
264
363
297
eat-threshold-s2
eat-threshold-s2
0
8
4.0
1
1
NIL
HORIZONTAL

SLIDER
191
328
363
361
shoot-threshold-s2
shoot-threshold-s2
0
36
40.0
1
1
NIL
HORIZONTAL

PLOT
1455
370
1820
545
peace
NIL
NIL
0.0
1000.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if (ticks > 0) [plot sum-tics-alive / (ticks * num-turtles)]"

PLOT
15
525
365
700
turtles alive
NIL
NIL
0.0
1000.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles with [not hidden?]"
"pen-1" 1.0 0 -1184463 true "" "plot count turtles with [strategy = 1 and not hidden?]"
"pen-2" 1.0 0 -2674135 true "" "plot count turtles with [strategy = 2 and not hidden?]"

PLOT
1455
190
1820
365
equality
NIL
NIL
0.0
1000.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot equality"

SLIDER
15
232
187
265
eat-vision-s1
eat-vision-s1
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
191
232
363
265
eat-vision-s2
eat-vision-s2
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
15
296
187
329
shoot-vision-s1
shoot-vision-s1
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
191
296
363
329
shoot-vision-s2
shoot-vision-s2
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
15
359
187
392
shoot-accuracy-s1
shoot-accuracy-s1
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
191
360
363
393
shoot-accuracy-s2
shoot-accuracy-s2
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
15
391
187
424
shoot-chance-s1
shoot-chance-s1
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
191
392
363
425
shoot-chance-s2
shoot-chance-s2
0
100
50.0
1
1
%
HORIZONTAL

TEXTBOX
17
83
167
103
Environment
14
0.0
1

TEXTBOX
17
161
167
181
Strategies
14
0.0
1

SWITCH
15
441
363
474
always-update-turtle-constants
always-update-turtle-constants
0
1
-1000

SWITCH
15
477
363
510
render?
render?
0
1
-1000

PLOT
1455
550
1820
725
sustainability
NIL
NIL
0.0
1000.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sustainability"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

robot
false
0
Rectangle -7500403 true true 105 30 195 90
Rectangle -7500403 true true 135 90 165 105
Rectangle -7500403 true true 105 105 195 180
Rectangle -7500403 true true 105 180 135 255
Rectangle -7500403 true true 165 180 195 255
Rectangle -7500403 true true 90 105 105 120
Rectangle -7500403 true true 75 105 90 195
Rectangle -7500403 true true 210 105 225 195
Rectangle -7500403 true true 195 105 210 120
Rectangle -1 true false 120 45 135 60
Rectangle -1 true false 165 45 180 60
Rectangle -7500403 true true 90 255 135 270
Rectangle -7500403 true true 165 255 210 270

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="smaller-space" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>set num-turtles-s2 12 - num-turtles-s1
setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>overall-avg-gain</metric>
    <metric>s1-avg-gain</metric>
    <metric>s2-avg-gain</metric>
    <metric>equality</metric>
    <metric>sum-tics-alive / (ticks * num-turtles)</metric>
    <metric>sum-time-gains / (sum [gain] of turtles + 0.001)</metric>
    <enumeratedValueSet variable="render?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="always-update-turtle-constants">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regrow-rate">
      <value value="10"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-turtles-s1" first="0" step="1" last="6"/>
    <enumeratedValueSet variable="num-turtles-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-treshold-s1">
      <value value="0"/>
      <value value="8"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-treshold-s2">
      <value value="0"/>
      <value value="8"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-treshold-s1">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-treshold-s2">
      <value value="0"/>
      <value value="1"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-timeout-s1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-timeout-s2">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SSD-experiment" repetitions="5" runMetricsEveryStep="false">
    <setup>set num-turtles-s2 2 - num-turtles-s1
setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>overall-avg-gain</metric>
    <metric>s1-avg-gain</metric>
    <metric>s2-avg-gain</metric>
    <metric>equality</metric>
    <metric>sum-tics-alive / (ticks * num-turtles)</metric>
    <metric>sum-time-gains / (sum [gain] of turtles)</metric>
    <enumeratedValueSet variable="render?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="always-update-turtle-constants">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spread-rate">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turtles-s1">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turtles-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-threshold-s1">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="4"/>
      <value value="8"/>
      <value value="12"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-threshold-s2">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="4"/>
      <value value="8"/>
      <value value="12"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="eat-threshold-s1" first="0" step="1" last="4"/>
    <steppedValueSet variable="eat-threshold-s2" first="0" step="1" last="4"/>
  </experiment>
  <experiment name="prison" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>set num-turtles-s2 12 - num-turtles-s1
setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>overall-avg-gain</metric>
    <metric>s1-avg-gain</metric>
    <metric>s2-avg-gain</metric>
    <metric>equality</metric>
    <metric>sum-tics-alive / (ticks * num-turtles)</metric>
    <metric>sum-time-gains / (sum [gain] of turtles + 0.001)</metric>
    <enumeratedValueSet variable="render?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="always-update-turtle-constants">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spread-rate">
      <value value="10"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-turtles-s1" first="0" step="1" last="12"/>
    <enumeratedValueSet variable="num-turtles-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-threshold-s1">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-threshold-s2">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-threshold-s1">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-threshold-s2">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="hunt" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>set num-turtles-s2 12 - num-turtles-s1
setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>overall-avg-gain</metric>
    <metric>s1-avg-gain</metric>
    <metric>s2-avg-gain</metric>
    <metric>equality</metric>
    <metric>sum-tics-alive / (ticks * num-turtles)</metric>
    <metric>sum-time-gains / (sum [gain] of turtles + 0.001)</metric>
    <enumeratedValueSet variable="render?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="always-update-turtle-constants">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spread-rate">
      <value value="10"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-turtles-s1" first="0" step="1" last="12"/>
    <enumeratedValueSet variable="num-turtles-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-accuracy-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-threshold-s1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-threshold-s2">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s1">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shoot-chance-s2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s1">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-vision-s2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-threshold-s1">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eat-threshold-s2">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
