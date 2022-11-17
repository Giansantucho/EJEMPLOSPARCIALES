class Rol {
	method tieneTodasLasHerramientas(herramientas) = false
	
	method estasDispuestoADefenderSector() = true
	
	method fuerza(fuerzaBase) = fuerzaBase
	
	method defendisteSector(empleado) {
		empleado.disminuirEstaminaEn(empleado.estamina() / 2)
	}
	
	method puedeLimpiarSector(empleado, sector) =
		empleado.estamina() >= sector.estaminaRequerida()
		
	method limpiasteSector(empleado, sector) {
		empleado.disminuirEstaminaEn(sector.estaminaRequerida())
	}
	
	method realizarTarea(empleado, tarea) {
		tarea.serRealizadaPor(empleado)
		empleado.hicisteTarea(tarea)
	}
	
	method puedeRealizarTarea(empleado, unaTarea) =
		unaTarea.requisitosSonCumplidosPor(empleado)
}

class Capataz inherits Rol {
	const subordinados = []
	
	override method realizarTarea(empleado, tarea) {
		const subordinadosQuePuedenHacerLaTarea = subordinados.filter { subordinado => tarea.puedeSerRealizadaPor(subordinado) }
		if(subordinadosQuePuedenHacerLaTarea.isEmpty()) {
			super(empleado, tarea)
		} else {
			const quienHaceLaTarea = subordinadosQuePuedenHacerLaTarea.max { subordinado => subordinado.experiencia() }
			quienHaceLaTarea.realizarTarea(tarea)
			empleado.hicisteTarea(tarea)
		}
	}
	
	override method puedeRealizarTarea(empleado, unaTarea) =
		subordinados.any {
			subordinado => subordinado.puedeRealizarTarea(unaTarea)
		} || super(empleado, unaTarea)
}

class Soldado inherits Rol {
	var danioExtraPorPractica = 0
	
	method danioExtraPorPractica() = danioExtraPorPractica 

	override method fuerza(fuerzaBase) = fuerzaBase + danioExtraPorPractica
	
	override method defendisteSector(_empleado) {
		danioExtraPorPractica += 2
	}
}

class Mucama inherits Rol {
	override method estasDispuestoADefenderSector() = false
	
	override method puedeLimpiarSector(_empleado, _sector) = true
	
	override method limpiasteSector(empleado, sector) {
	}
}

class Obrero inherits Rol {
	const herramientasEnCinturon = []

	override method tieneTodasLasHerramientas(herramientasNecesarias) =
		herramientasNecesarias.all { herramienta =>
			herramientasEnCinturon.contains(herramienta)
		}
}

class Empleado {
	var estamina = 0
	const tareasRealizadas = []
	const rol = new Obrero()

	method estamina() = estamina
	
	method experiencia() =
		tareasRealizadas.sum { tarea =>
			tarea.dificultadPara(self)
		} * tareasRealizadas.size()
	
	method comer(fruta) {
		estamina = self.estaminaResultanteTrasComer(fruta)
	}
	
	method disminuirEstaminaEn(cantidad) {
		estamina -= cantidad
	}
	
	method hicisteTarea(unaTarea) {
		tareasRealizadas.add(unaTarea)
	}

	method realizarTarea(unaTarea) {
		rol.realizarTarea(self, unaTarea)
	}

	method estaminaResultanteTrasComer(fruta) {
		return estamina + fruta.estaminaQueRecupera()
	}
	
	method fuerza() {
		return rol.fuerza(estamina / 2 + 2)
	}
	
	method estasDispuestoADefenderSector() {
		return rol.estasDispuestoADefenderSector()
	}
	
	method tieneTodasLasHerramientas(herramientas) {
		return rol.tieneTodasLasHerramientas(herramientas)
	}
	
	method defendisteSector() {
		return rol.defendisteSector(self)
	}
	
	method puedeLimpiarSector(sector) {
		return rol.puedeLimpiarSector(self, sector)
	}
	
	method limpiasteSector(sector) {
		return rol.limpiasteSector(self, sector)
	}
	
	method puedeRealizarTarea(unaTarea) {
		return rol.puedeRealizarTarea(self, unaTarea)
	}
}

class Ciclope inherits Empleado {
	method dificultadDeDefenderUnSector(defenderSector) =
		defenderSector.gradoDeAmenaza() * 2
	
	override method fuerza() = super() / 2
}

class Biclope inherits Empleado {
	method limiteDeEstamina() = 10
	
	method dificultadDeDefenderUnSector(defenderSector) =
		defenderSector.gradoDeAmenaza()

	override method estaminaResultanteTrasComer(fruta) {
		return super(fruta).min(self.limiteDeEstamina())
	}
}

object uva {
	method estaminaQueRecupera() = 1
}

object manzana {
	method estaminaQueRecupera() = 5
}

object banana {
	method estaminaQueRecupera() = 10
}

