
model tetris

global{
	geometry shape <- square(30) ;
	float size_box <- 1 ;
	int n_pieces ;
	bool to_create ;
	bool left <- false ;
	bool right <- false ;
	int surface ;
	init{
		to_create <- false ;
		n_pieces <- 1 ;
		create pieces ;
		
	}
	
	reflex creation{
		
		if(to_create){
			create pieces ;
			to_create <- false ;
			n_pieces <- n_pieces + 1 ;
		}
	}
	action black{
		loop p from:0 to:length(pieces.population)-1{
			ask pieces.population at p{
				if (self.dead=true){
					self.col <-#black;
				}
			}
	}
	}
	action left{
		int rank <- n_pieces -1 ;
		ask pieces.population at rank{
			self.posx <- self.posx-1 ;
			do update_l ;
		}
	}
	action right{
		int rank <- n_pieces -1 ;
		ask pieces.population at rank{
			self.posx <- self.posx+1 ;
			do update_r ;
		}
	}
	action rotate{
		int rank <- n_pieces -1 ;
		ask pieces.population at rank{
			self.posx <- self.posx+1 ;
			do rotation;
		}
	}
	action accelerate{
	int rank <- n_pieces -1 ;
		ask pieces.population at rank{
			self.posx <- self.posx+1 ;
			do descente;
		}
	}
	
	
	


}

species pieces skills:[moving]{
	int number <- rnd(1,4);
	rgb col <- rgb(rnd(1,255),rnd(1,255),rnd(1,255)) ;
	float posx  ;
	float posy ;
	float sizex ;
	float sizey ;
	bool dead ;
	int id ;
	
	init{
		
		id <- n_pieces ;
		posx<-10;
		posy<-0;
		sizex<-2*rnd(1,number);
		sizey<-2*rnd(1,number);
		dead <- false ;
		location <- {posx,posy} ; 
		surface <- surface + sizex*sizey ;
	}
	
	user_command cmd_inside_experiment action:die;
	aspect shape{
		draw rectangle(30,0.1) color:#purple border:#purple at:{15,10};
		draw rectangle(sizex,sizey) color:col border:#black ;
		
	}
	action movem{
		bool movement <- true ;
		
		loop p from:0 to:length(pieces.population)-1{
			ask pieces.population at p{
				
				if(((self.posx-self.sizex/2< myself.posx+myself.sizex/2 and self.posx+self.sizex/2> myself.posx-myself.sizex/2) and (self.posy - self.sizey/2 < myself.posy+myself.sizey/2 and self.posy+self.sizey/2> myself.posy-myself.sizey/2) and myself.id!=self.id)){
					movement <- false ;
			}
				
			}
		}
		if(movement and location.y<30){
				
				do goto target:{location.x,location.y+0.1} ;	
				
			}
		if(!movement or location.y>=30-sizey/2) {
				dead <- true ;
				to_create <- true ;
		
			}
		
	}
	
	reflex save{
		save [posx,posy,sizex,sizey] to:"positions.csv" type:"csv" ;
	}
	
	
	reflex update_pos{
		posx <- location.x;
		posy <- location.y ;
	}
	reflex test_alive{
		if(self.dead=false){
			do movem ;
		}
	}
	reflex lost{
		if(dead and location.y<=10 and n_pieces>1){
			write("loser");
			draw "You Lost" ;
			
		}
	}
	action update_l{
		do goto target:{location.x-1,location.y} speed:1 ;
		left <- false ;
		
	}
	
	action update_r{
		do goto target:{location.x+1,location.y} speed:1 ;
		left <- false ;
		
	}
	
	action rotation{
		float stockx <- sizex ;
		sizex <- sizey ;
		sizey <- stockx ;
	}
	action descente{
		do goto target:{location.x,location.y+0.5} speed:1 ;
	}
	
}

experiment game type:gui{
	
	
	output{
		
		monitor nombre value:n_pieces ;
		inspect "number" value:pieces attributes:["posx","posy","sizex","sizey"] type:table ;
		
		display game{
			species pieces aspect:shape;
			
			event 'b' action:black;
			event 'q' action:left;
			event 's' action:right;
			event 'r' action:rotate ;
			event ' ' action: accelerate ;
		}
		display datas{
			chart "volume" type:series{
				data "Surface" value:surface color:#purple ;
			}
		}
	}
}

