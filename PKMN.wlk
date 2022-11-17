

class Pokemon{
	const vidaMaxima
	const movimientos = []
	var vida = 0
	var property condicion = normal 
	
	method grositud() = vidaMaxima * movimientos.sum{movimiento => movimiento.poder()}
	
	method curar(pSalud) {
		vida = (vida + pSalud).min(vidaMaxima)
	}
	
	method recibirDanio(danio) {
		vida = 0.max(vida-danio)
	}
	
	method lucharContra(contrincante){
		self.validarVida()
		const movAUsar = self.movDisponible()
		condicion.intentaMoverse(self)
		movAUsar.usarEntre(self,contrincante)
		
	}
	
	method movDisponible() {
		return movimientos.find{movimiento => movimiento.cantUsos() > 0}
	}
	
	method normalizar(){
		condicion = normal
	}
	
	method validarVida(){
		if(vida == 0) throw new DomainException(message='está debilitado')
	}
}

//// MOVS 

class Movimiento{
	var property cantUsos = 0
	
	method usarEntre(usuario, contrincante){
		if(cantUsos < 0) throw new DomainException(message="movimiento no disponible")
		cantUsos -= 1
	    self.afectar(usuario,contrincante)
	}
	
	method afectar(usuario,contrincante)
}

class MovCurativo inherits Movimiento{
	const pSalud
	method poder() = pSalud
	
	override method afectar(usuario,contrincante){
		 usuario.curar(pSalud)
	} 
}

class MovDanino inherits Movimiento{
	const danio
	
	method poder() = 2*danio
	
	override method afectar(usuario,contrincante) {
		contrincante.recibirDanio(danio)
	}
}

class MovEspecial inherits Movimiento{
	const condicion
	method poder()  = condicion.poder()
	
	override method afectar(usuario,contrincante){
		contrincante.condicion(condicion)
	}
}


/////CONDICIONES

class Condicion{
	method poder()
	method intentaMoverse(pokemon){
		if(! self.lograMoverse())
			throw new NoPuedeMoverseException(message = "El pokemon no pudo moverse")
	}
	
	
	method lograMoverse() = 0.randomUpTo(2).roundUp().even()
}

object normal {
method intentaMoverse(pokemon){
	
}

}

object movSuenio inherits Condicion{
	override method poder() = 50


}

object movParalisis inherits Condicion{
	override method poder() = 30
	
	override method intentaMoverse(pokemon){
		super(pokemon)
		pokemon.normalizar()
	}
	}
	
class Confusion inherits Condicion {
	const turnosQueDura = 0
	
	override method poder() = 40 * turnosQueDura
	override method intentaMoverse(pokemon){
		self.pasoUnTurno(pokemon)
		
		try {
			super(pokemon)
		}
		catch e : NoPuedeMoverseException {
			pokemon.recibirDanio(20)
			throw new NoPuedeMoverseException(
				message = "El pokémon no pudo moverse y se hizo daño a sí mismo",
				cause = e
			)
		}
	}
	method pasoUnTurno(pokemon){
		if(turnosQueDura > 1){
			pokemon.condicion(new Confusion(turnosQueDura = turnosQueDura - 1))
		} else {
			pokemon.normalizar()
		}
	}
}

class NoPuedeMoverseException inherits Exception {}