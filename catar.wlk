class Plato {
	const baseCalorias = 100
	const property cocinero
	
	method cantidadAzucar()
	

	method cantidadCalorias() = 3 * self.cantidadAzucar() + baseCalorias
}

class Entrada inherits Plato {
	method esBonito() = true
	override method cantidadAzucar() = 0
}

class Principal inherits Plato {
	const esBonito
	const cantidadAzucar
	
	method esBonito() = esBonito
	override method cantidadAzucar() = cantidadAzucar
}

class Postre inherits Plato {
	const cantColores
	
	method esBonito() = cantColores > 3 
	override method cantidadAzucar() = 120
}


class Cocinero{
	
	var property tipoCocinero 
	
	
	method catarPlato(plato){
    	return tipoCocinero.criterioPuntuacion(plato)
    }
	

	
	method cambiarEspecialidad(nuevoTipoCocinero){
		tipoCocinero = nuevoTipoCocinero
	}
		
	
}

class Chef{
	
 var property caloriasNecesarias = 0
	
	 method criterioPuntuacion(plato){
		if(self.cumple(plato)) return 10
		else return 0
		
	}
	
	method cumple(plato){
		return plato.esBonito() && self.tieneCaloriasNecesarias(plato)
	}
	
	method tieneCaloriasNecesarias(plato){
		return plato.caloriasPlato() == caloriasNecesarias
	}
	
	method cocinar(elCocinero) = new Principal( cocinero= elCocinero, esBonito = true, cantidadAzucar = caloriasNecesarias)
}




class Pastelero {
	
	var property nivelDeseadoDulzor = 0
	
     method criterioPuntuacion(plato){
		return (5*plato.azucar()/nivelDeseadoDulzor).min(10)
	}
	
	method cocinar(elCocinero){
		return new Postre(cocinero= elCocinero, cantColores = nivelDeseadoDulzor/50 )
	}
	
	
}

object souschef inherits Chef{
	
	override method criterioPuntuacion(plato){
		if(not self.cumple(plato)){
			return plato.caloriasPlato()/100.min(6)
		}
		else return 0
	}
	
	override method cocinar(elCocinero) = new Entrada(cocinero = elCocinero)
	
}

object torneo{
	const catadores = []
	const cocinerosParticipantes = []
	
	method sumarParticipacion(cocinero) {
		cocinerosParticipantes.add(cocinero.cocinar())
	}
	
	method ganador() {
		if (cocinerosParticipantes.isEmpty()) 
			throw new DomainException(message = "No se puede definir el ganador de un torneo sin participantes")
		return cocinerosParticipantes.max({plato => self.calificacionTotal(plato)}).cocinero()
	}
	
	method calificacionTotal(plato) = catadores.sum({catador => catador.catar(plato)})
}




