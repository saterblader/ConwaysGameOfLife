set size_y 19
set size_x 78
set delay 100
set grid ""
set cycle 0

proc gen_grid {} {
	upvar grid _grid
	upvar size_y _y
	upvar size_x _x
	for {set i 0} {$i<$_y} {incr i} {
		set row ""
		for {set j 0} {$j<$_x} {incr j} {
			lappend row [expr {[expr {int(0 + rand() * (1 - 0 + 1))}] ? "*" : " "}]
		}
		lappend _grid $row
	}
}

proc print_grid {} {
	upvar grid _grid
	upvar size_x _x
	upvar cycle _cycle
	puts -nonewline "\033\[2J\033\[H"
	puts -nonewline "Conway's Game of Life!"
	for {set i 0} {$i<$_x-27-[string length $_cycle]} {incr i} {
		puts -nonewline " "
	}
	puts "cycle: $_cycle"
	for {set i 0} {$i<$_x+2} {incr i} {
		puts -nonewline "="
	}
	puts ""
	foreach row $_grid {
		puts -nonewline "|"
		foreach idx $row {
			puts -nonewline $idx
		}
		puts "|"
	}
	for {set i 0} {$i<$_x+2} {incr i} {
		puts -nonewline "="
	}
	puts ""
	puts "Implemented in Tcl, Philip Geramian 2026"
}

proc update_grid {} {
	upvar grid _grid
	upvar size_y _y
	upvar size_x _x
	upvar cycle _cycle
	set new_grid ""
	for {set y 0} {$y<$_y} {incr y} {
		set row ""
		for {set x 0} {$x<$_x} {incr x} {
			set neighbors 0
			#If we are the first row, don't look above
			if {[expr {$y!=0}]} {
				#If we are the first element, don't look left
				if {[expr {$x!=0}]} {
					if {[string equal "*" [lindex $_grid [expr {$y-1}] [expr {$x-1}]]]} {
						incr neighbors
					}
				}
				if {[string equal "*" [lindex $_grid [expr {$y-1}] $x]]} {
					incr neighbors
				}
				#If we are the last element, don't look right
				if {[expr {$x!=$_x-1}]} {
					if {[string equal "*" [lindex $_grid [expr {$y-1}] [expr {$x+1}]]]} {
						incr neighbors
					}
				}
			}
			#If we are the first element, don't look left
			if {[expr {$x!=0}]} {
				if {[string equal "*" [lindex $_grid [expr {$y}] [expr {$x-1}]]]} {
					incr neighbors
				}
			}
			#If we are the last element, don't look right
			if {[expr {$x!=$_x-1}]} {
				if {[string equal "*" [lindex $_grid $y [expr {$x+1}]]]} {
					incr neighbors
				}
			}
			#If we are the last row, don't look below
			if {[expr {$y!=$_y-1}]} {
				#If we are the first element, don't look left
				if {[expr {$x!=0}]} {
					if {[string equal "*" [lindex $_grid [expr {$y+1}] [expr {$x-1}]]]} {
						incr neighbors
					}
				}
				if {[string equal "*" [lindex $_grid [expr {$y+1}] $x]]} {
					incr neighbors
				}
				#If we are the last element, don't look right
				if {[expr {$x!=$_x-1}]} {
					if {[string equal "*" [lindex $_grid [expr {$y+1}] [expr {$x+1}]]]} {
						incr neighbors
					}
				}
			}
			if {[string equal "*" [lindex $_grid $y $x]]} {
				if {[expr {$neighbors < 2}] || [expr {$neighbors > 3}]} {
					lappend row " "
				} else {
					lappend row "*"
				}
			} elseif {[expr {$neighbors == 3}]} {
				lappend row "*"
			} else {
				lappend row " "
			}
		}
		lappend new_grid $row
	}
	set _grid $new_grid
	incr _cycle
}


gen_grid
print_grid
#Give the user 5 seconds to adjust display size
after 5000
while {1} {
	after $delay
	update_grid
	print_grid
}
