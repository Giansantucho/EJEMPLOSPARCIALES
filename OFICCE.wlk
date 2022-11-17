class Empleado{
	var property anioAnt = 0
    var property cargo
    var property sucursal 
    var property personalidad 
    var property inseguridad = true
    var property ejecutivo = false 

	method sueldoMensual() = self.sueldoBase() + 100 * anioAnt
	
	 method sueldoBase() = cargo.sueldo(self)
	 
	 method recategorizar(nuevoCargo) {
	 	
	 	if(!sucursal.esViable()) throw new DomainException(message='no es viable recategorizar')
	 	
	 	cargo = nuevoCargo
	 	
	 }
	 
	 
	 method transferirASucursal(nuevaSucursal) {
	 	if(!nuevaSucursal.esViable() && sucursal.cantEmpleados() < 3 ) 
	 	throw new DomainException(message='No es posible hacer cambio de surcusal')
	 	
	 	sucursal = nuevaSucursal
	 } 
	 
	 method motivacionEmpleado(){
        return personalidad.motivacionPorPersonalidad(self)
    }
    
    
    method esInsegura(){
    return self.inseguridad(true)
    }
    
   }
/// cargos

class Cargo{
	var property cantHoras
	method diasLaborales () = 22

    method sueldo(empleado) = empleado.sueldoHora() * (cantHoras.max(4)).min(8) * self.diasLaborales()

    method sueldoEjecutivo(empleado)

}


class Recepcionista inherits Cargo {
 method sueldoHora() = 15 
}

class Pasante inherits Cargo{
	var property diasQueSeToman = 0
	 method sueldoHora() = 10 
	 override method diasLaborales(){
	 	return self.diasLaborales() - diasQueSeToman
	 }
}

class Gerente inherits Cargo{
	const property cantColegas = 0 
	
 method sueldoHora() = 8 * cantColegas 
}


////////
////SUCURSAL
///////

class Sucursal {
	var property presupuesto = 1000
	const listaEmpleados = []
	
	method cantEmpleados() = listaEmpleados.size()
	
	method esViable() = presupuesto >= self.sueldoTotal()
	
	method sueldoTotal() = listaEmpleados.sum{empleado => empleado.sueldoMensual()}
	
	method empleadosQueCobranMas(unEmpleado){
        return (listaEmpleados.filter{otroEmpleado => otroEmpleado.sueldoMensual() > unEmpleado.sueldoMensual()}).size()
    }
    
    method cambiarAEjecutivo(empleado) {
    	if(empleado.esInsegura()){
		empleado.esEjecutivo(true)}}
		
	method mejorParaTrabajarQueOtra(otraSucursal){
		return self.esViable() && self.mayorPromedioDeMotivacionQue(otraSucursal) 
	}
	
	method mayorPromedioDeMotivacionQue(otraSucursal) = self.promedioMotivacionEmpleados() > otraSucursal.promedioMotivacionEmpleados()
	
	method promedioMotivacionEmpleados() = listaEmpleados.sum{empleado=> empleado.motivacion()} / self.cantEmpleados()
	
	
}

///////
///// Personalidad 
//////

class Personalidad{
     
    method motivacionPorPersonalidad(empleado){
        return (empleado.personalidad().motivacion(empleado).max(0)).min(100)
    }
    
     method motivacion(empleado)
}

class Competitiva inherits Personalidad{
	
	 override method motivacion(empleado) = 100 - 10 * empleado.sucursal().cantQueMasCobran()
}

class Sociable inherits Personalidad{
	 override method motivacion(empleado) = 15 * (empleado.sucursal().cantEmpleados() - 1)
}

class Indiferente inherits Personalidad{
	var property valorMotiv
	 override method motivacion(empleado) = valorMotiv
}

class Compleja inherits Personalidad{
	const personalidades = []
	
	method sumaMotiv(empleado) = personalidades.sum{personalidad => personalidad.motivacion(empleado)}
	method cantPerson(empleado) = personalidades.size()
	
	override method motivacion(empleado) = self.sumaMotiv(empleado) / self.cantPerson(empleado)
}

object insegura inherits Personalidad{
	var property valorMotiv = 0
	override method motivacion(empleado) =  valorMotiv * 0.1
}



