////////
//Contenidos
///////

class Contenido{
	var property titulo
	var property vistas = 0
	var property ofensivo = false
	var property monetizacion
	
	method recaudacion(){
		return monetizacion.recaudacionDe(self)
	}
	
	method esPopular()
	method recaudacionMaximaPublicidad()
	method puedeVenderse() = self.esPopular()
	method puedeAlquilarse()
}

class Video inherits Contenido{
	
	override method recaudacionMaximaPublicidad() = 10000
	
	override method esPopular(){
	return self.vistas() >  10000
	}
	
	override method puedeAlquilarse() = true
}

const tagsDeModa = ["objetos" ,"pdp", "serPeladoHoy"]

class Imagen inherits Contenido{
	var property tags = []

	override method esPopular(){
	tagsDeModa.all{tag => tags.contain(tag)}
	}
	
	override method recaudacionMaximaPublicidad() = 4000
	
	override method puedeAlquilarse() = false
}


////////
//Monetizacion
///////

object publicidad{
	method recaudacionDe(contenido){
		return ((0.05)*contenido.vistas() + 
		if(contenido.esPopular()) 2000 else 0).min(contenido.recaudacionMaximaPublicidad())
		}
		
	method puedeAplicarse(contenido) = !contenido.ofensivo()
}

class Donacion{
	var property donaciones = 0
	method recaudacionDe(contenido){
		return donaciones
	}
	
	method puedeAplicarse(contenido) = true
}
	
	


class Descarga{
	var property precioDescarga = 0
	
	method recaudacionDe(contenido){
		return 5.max(precioDescarga * contenido.vistas())
	}
	
	method puedeAplicarse(contenido) = contenido.puedeVenderse()
	
}

class ElAlquiler inherits Descarga{
	override method precioDescarga(){
		return 1.max(super())
	}
	
	override method puedeAplicarse(contenido) = super(contenido) && contenido.puedeAlquilarse()
}

////////
//USUARIOS
///////

object usuarios{
	const todosLosUsuarios  = []
	
	method emailsDeUsuariosRicos(){
		return todosLosUsuarios.filter({usuario => usuario.verificado()})
		.sortedBy({uno, otro => uno.saldoTotal() > otro.saldoTotal()})
		.take(100)
		.map{usuario => usuario.email()}
	}
	
	method cantidadSuperUsuarios(){
		return todosLosUsuarios.count({usuario => usuario.esSuperUsuario()})
	}
}

class Usuario{
	const property nombre
	const property email
	var property verificado = false
	const property contenidos = []
	
	method saldoTotal(){
		return contenidos.sum({contenido => contenido.recaudacion()})
	}
	
	method esSuperUsuario(){
		return contenidos.count({contenido => contenido.esPopular() >= 10})
	}
	
	method publicarContenido(contenido, monetizacion){
		if(!monetizacion.puedeAplicarse(contenido)){
		throw new DomainException(message= "el contenido no soporta la toma de monetizacion")}
		
		contenido.monetizacion(monetizacion)
		contenidos.add(contenido)
	}
	
}
