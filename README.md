# GraphicsProjectTwo

##Designer mode
* Make cuts.  Open request to cut:
 * Check if the cutter line is legal (is at least partially inside the shape and only makes a single legal cut)
 * Find the points to cut at.
 * Divide the polygon being cut into two more polygons.
 * We need to keep track of shared edges somehow.
* Move shapes out of starting area.
 * Maintain a ghost image of the original starting area as a polygon.
 * Allow polygons to be translated, rotated, and scaled.  Do not allow them to be overlapping the starting area or each other when save is attempted.
* Save changes.
 * As a bunch of polygons; their shared edge information needs to be saved as well.

##Player mode
* Click shared edges to move pieces into the start.  They will attempt to go there in a logarithmic spiral motion.  Return if wrong place or collide with an unplaced piece.  Correctly placed pieces should be immune to collision.
