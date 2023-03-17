# 100 days of graphics

# day 1
* resources
  * https://learnopengl.com/ - a intro to OpenGL 3.0 book
* did
 * create window with glfw
 * get access to OpenGL 3.0 apis
 * figure out how to mange screen resize
* struggles
 * working with c pointers is hard
 * not sure how to manage gl version correctly
 * learned that i cant use closures the way i want to, need to lose js brain
 * never really got a good wraper for glfw

# day 2
* resources
  * https://glad.dav1d.de/ - glad generator
  * https://www.glfw.org/ - glfw docs
* did
  * read some glfw docs to better understand init process
    * init glfw
    * ?set window hints
    * create window
    * make glad
    * create while window open loop
    * -- handle events
    * -- render gl stuff
    * -- swap buffers
    * -- poll for events
    * free window
    * free glfw
  * used glad website generator to make my own custom glad.c and glad.h for
    OpenGL 3.3
  * figured out how to use window hints in glfw to select an OpenGL verions
    * did an expierment to show that bad version will fail to create window
  * managed to make a much better wrapper for glfw, but still needs work
  * figured out how to handle input
  * created a simple Throttle and Debouce struct that use state to allow you to
    throttle behavior on an event handler without blocking, in a single threaded
    program
* struggles
  * still struggling to figure out a nice interface for glfw
