
model Equadiff


global{
	int t <- t update:t + 0.1 ;
	float fglob ;
	float oglob ;
	init{
	create eq ;
	}
	reflex egal{
		fglob <- (eq.population at 0).f ;
		oglob <- (eq.population at 0).o ;
	}
	 
}



species eq{
	float o ;
	float f ;
	float a <- 0.5 ;
	float b <- 0.8 ;
	float c <- 0.1 ;
	float t ;
	init{
		f <- 1 ;
		o <- 2 ;
	}
	equation eq{
		diff(f,t) = c*f + a -b*o;
		diff(o,t) = b*f - c*o ;
		
	}
	reflex solving {solve eq method: #rk4 step_size: 0.1 ;
		
	}
	 
}

experiment resol type:gui{
	output{
		display resultat{
			chart "results" type:series{
				data "f" value:fglob color:#red ;
				data "o" value:oglob color:#blue ;
			}
		}
	}
}