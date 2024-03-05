globals [
  global-population
]

;; TODO: globals and local ------------
turtles-own [
  local-population
  virus? ;; has virus [true/false]
  recovered ;; is recovered [true/false]
  exposed ;; is exposed [true / false]
  virus_duration ;; how long our agent already has a virus
]

to setup
  clear-all
  setup-world
  create-turtles 100 [
    setxy random-xcor random-ycor
    set local-population true
    set virus? false set shape "person"
    set recovered false set exposed false
  ]
  set global-population count turtles

  ;; Tutles setup
  ask one-of turtles [set virus? true] ;;one gets infected
  ask turtles [recolor]

  reset-ticks
end


to setup-world
  resize-world -20 20 -20 20
  ;; Define radius of the circular local population area
  let radius 14

   ;; Create circular local population area
  ask patches [
    ifelse (sqrt(pxcor * pxcor + pycor * pycor) <= radius)
    [ set pcolor green ]
    [ set pcolor white ]
  ]

  let quarantine-x -8  ;; Custom x-coordinate for quarantine area
  let quarantine-y 15   ;; Custom y-coordinate for quarantine area
  ;; Create a quarantine area
  ask patches with [pxcor <= quarantine-x and pycor >= quarantine-y] [
    set pcolor orange
  ]

end


to go ;; each tick of simulation turtle do this
  ;; if all? turtles [recovered?] [stop]
  ;;if all? turtles [virus?] [stop]
  ;;if all? turtles [virus? = false] [stop]
  while [any? turtles with [virus?]] [ 
    ask turtles [
      move
      spread
      recover
      recolor
    ]
    tick
  ]
  
end


;; TO DO: ------------------
to move
  if recovered = false
  [
    right random 150
    left random 150

    fd 1
  ]
end


to recover ;; if our agent has virus, he con recover under probability and after some virus_duration but he has also a chance to die
  if virus? [
    set virus_duration virus_duration + 1
    if random-float 1.0 < recover_probability and virus_duration > 10 [ ;; chance to recover
      set virus? false
      set recovered true
    ]
  ]
end


;; TO DO: for exposed turtles  ---------------
to spread ;; Turtle-Turtle interactions (AxA)
  ifelse virus? [] [
    if any? other turtles-here with [virus?] [set virus? true] ;; checking if there is virus near this agent
  ]
end


to recolor ;; recolors agent based on their virus? state [red-infected, blue - not infected ]
  ifelse virus? [set color red] [set color blue]
  if exposed [set color yellow]
  if recovered [set color green]
end


;; TODO: Infected turtles in global space will go to quarantined area, then limit movement
;; TODO: Detect whether in local area or global area??
;; TODO: Formulations n stuff
;; TODO: Plotting table
;; mao ni akoang tots so far, tenks