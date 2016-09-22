# GraphicsProjectTwo

## Dependencies
* In order to run this project, it is necessary to install ControlP5 through processing.  Go to Tools>Add Tool>Libraries, search ControlP5 in the filter, and install.

The project opens into base polygon editing mode.  Here you can add, delete, and move points to create the base polygon.  Buttons help guide the user through the stages.
The next mode is cutting.  Here the designer cuts the polygon into pieces.  The old paradigm of holding s and dragging the mouse is used to create the arrow.  To make a cut, press k once.  Repeat until satisfied, then go to the next mode.
In translate mode, the designer moves cut pieces out of the base polygon so that none are overlapping each other or the base polygon.  The base controls, where t+drag = translate, r+drag = rotate, and mousewheel = scale remain.
Finally, in translate mode, a play button appears. Hitting the play button moves to player mode.  As the player, select polygons outside the base and click where it should go inside the base in order to attempt to move it there.  The polygon will stop and go back if it collides with any unplaced polygons, but placed polygons do not cause collisions (in order to prevent making life very hard for the designer).

A note: If the piece was removed from the center during translate mode and little to no rotation was applied, the piece will choose to LERP back to the center to be placed.  Otherwise, it will use a logarithmic spiral movement.
