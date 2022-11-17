class Tarea {
	method serRealizadaPor(empleado) {
		if(not self.puedeSerRealizadaPor(empleado)) {
			self.error("No se cumplieron los requerimientos para realizar la tarea")
		}
		self.seRealizoLaTarea(empleado)
	}
	
	method seRealizoLaTarea(empleado)
	
	method puedeSerRealizadaPor(empleado) {
		return empleado.puedeRealizarTarea(self)
	}
	
	method requisitosSonCumplidosPor(empleado)
}

class ArreglarMaquina inherits Tarea {
	const complejidadDeLaMaquina
	const herramientasNecesarias = []
	
	method dificultadPara(_empleado) = complejidadDeLaMaquina * 2
	
	override method seRealizoLaTarea(empleado) {
		empleado.disminuirEstaminaEn(complejidadDeLaMaquina)
	}
	
	override method requisitosSonCumplidosPor(empleado) {
		return (empleado.estamina() >= complejidadDeLaMaquina) &&
			empleado.tieneTodasLasHerramientas(herramientasNecesarias)
	}
}

class DefenderSector inherits Tarea {
	const gradoDeAmenaza
	
	method gradoDeAmenaza() = gradoDeAmenaza
	
	method dificultadPara(empleado) {
		return empleado.dificultadDeDefenderUnSector(self)
	}
	
	override method requisitosSonCumplidosPor(empleado) {
		return empleado.estasDispuestoADefenderSector() && empleado.fuerza() >= gradoDeAmenaza
	}
	
	override method seRealizoLaTarea(empleado) {
		empleado.defendisteSector()
	}
}

class LimpiarSector inherits Tarea {
	const grande = false

	method dificultadPara(_empleado) = tareasDeLimpieza.dificultad()
	
	override method requisitosSonCumplidosPor(empleado) = empleado.puedeLimpiarSector(self)
	
	method estaminaRequerida() = if(grande) 4 else 1
	
	override method seRealizoLaTarea(empleado) {
		empleado.limpiasteSector(self)

	}
}

object tareasDeLimpieza {
	var dificultad = 10
	
	method dificultad() = dificultad

	method configurarDificultad(nuevaDificultad) {
		dificultad = nuevaDificultad
	}
}