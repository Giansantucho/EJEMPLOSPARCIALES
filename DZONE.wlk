class Mision{
	const habilidadesRequeridas = []
	const peligrosidad
	
	method serCumplidaPor(unidadAsignada) {
		self.validarHabilidades(unidadAsignada)
		unidadAsignada.recibirDanio(peligrosidad)
		unidadAsignada.finalizarMision(self)
		}
		
	method validarHabilidades(asignado){
		if(!self.reuneHabilidadesRequeridas(asignado)){
			self.error("no se puede cumplir la mision")
		}
		
		
		}
	
	method enseniarHabilidades(empleado) {
		self.habilidadesQueNoPosee(empleado)
			.forEach({hab => empleado.agregarHabilidad(hab)})
	}
	
	method reuneHabilidadesRequeridas(unidadAsignada){
		return habilidadesRequeridas.all{hab => unidadAsignada.puedeUsar(hab)}
	}
	
	method habilidadesQueNoPosee(empleado) {
		return habilidadesRequeridas.filter({hab => not empleado.poseeHabilidad(hab)})
		}
		
}



////////////
////EMPLEADO
///////////
class Empleado{
	var property salud = 100
	const habilidades = []
	var property puesto 
	
	method saludCritica() = puesto.saludCritica()
	
	method estaIncapacitado(){
		return salud < self.saludCritica()
	}
	
	method recibirDanio(cantidad){
		salud -= cantidad
	}
	
	method agregarHabilidad(habilidad){
		habilidades.add(habilidad)
	}
	
	method puedeUsarHabilidad(habilidad){
		return (not self.estaIncapacitado()) && self.poseeHabilidad(habilidad)
	}
	
	method poseeHabilidad(habilidad){
		return habilidades.contains(habilidad) 
	
	}
	
	method estaVivo() = salud > 0
	
	method finalizarMision(mision){
		if(self.estaVivo()){
			self.completarMision(mision)
		}
	}
	
	method completarMision(mision){
		puesto.completarMision(mision,self)
	}
}

class Jefe inherits Empleado{
	const subordinados = []
	
	override method poseeHabilidad(habilidad){
		return super(habilidad) 
		||  self.algunSubordinadoLaTiene(habilidad)
		}
	
	method algunSubordinadoLaTiene(habilidad){
		return subordinados.any{subordinado => subordinado.puedeUsarHabilidad(habilidad)}
	}
}

//////////
////PUESTOS
//////////



object espia {
 method saludCritica() = 15
	
method completarMision(mision,empleado){
	mision.enseniarHabilidades(empleado)
}

}



class Oficinista {
	var property cantEstrellas
	
	 method saludCritica() = 40 - 5 * cantEstrellas
	 
	method completarMision(mision,empleado){
	    cantEstrellas += 1
		if (cantEstrellas == 3) {
			empleado.puesto(espia)
		}
}

}

///////
//EQUIPO
////////
class Equipo {
	const empleados = []
	
	method puedeUsarHabilidad(habilidad) = 
		empleados.any({empleado => empleado.puedeUsarHabilidad(habilidad)})
		
	method recibirDanio(cantidad) {
		empleados.forEach({empleado => empleado.recibirDanio(cantidad / 3)})
	}
	
	method finalizarMision(mision) {
		empleados.forEach({empleado => empleado.finalizarMision(mision)})
	}
}

	


