object sistemaTurismo {
	var property cotizacion = 100
	const turistas = []
	const sitios = []
	
	method agregarTurista(t){
		turistas.add(t)
	}
	
	method agregarSitio(s){
		sitios.add(s)
	}

	
	method pasoUnAnio(){
		turistas.forEach{t=> t.cumplirAnios()}
	}
	
	method sitiosVisitables(turista,pais) =
		self.sitioDelPais(pais).filter{s=>s.puedeSerVisitado(turista)}
	
	method sitioMasVisitadoPorMenores() = 
		sitios.max{s=>s.cantidadVisitasMenores()}
		
	method visitoAlgoEnPais(turista,pais) = 
		self.sitioDelPais(pais).any{s=>s.fueVisitadoPor(turista)}
	
	method sitioDelPais(pais) =
		sitios.filter{s=>s.pais() == pais}
		
	method repartoMillas(){
		turistas.forEach{t=> self.reparteMillasA(t)}
	}
	method reparteMillasA(turista) {
		sitios.filter{s=>s.fueVisitadoPor(turista)}
			.forEach{s=>s.darMilla(turista)}
		turista.efectuarPenalidades()
	}
	method nuncaVisito(turista, categoria) =
		not sitios.any{
			s=> s.categoria() == categoria && 
			s.fueVisitadoPor(turista)
		}
	
} 


class Turista{
	var edad
	var millas
	const preferencias = []
	
	method agregarPreferencia(categoria){
		preferencias.add(categoria)
	}
		
	method quitarPreferencia(categoria){
		preferencias.remove(categoria)
	}
	
	method prefiere(categoria) = preferencias.contains(categoria)
	
	method puedePagar(importe) =
		millas * sistemaTurismo.cotizacion() >= importe
	
	method menor() = edad < 18
	method adultoMayor() = edad >= 70
	
	method cumplirAnios(){
		edad += 1
	}
	
	method pagar(importe) {
		millas -= importe / sistemaTurismo.cotizacion()
	}
	method premio(millasPremio){
		millas += millasPremio
	}
	method efectuarPenalidades(){
		preferencias.forEach{p=>self.efectuarPenalidad(p)}
	}
	method efectuarPenalidad(categoria) {
		if(sistemaTurismo.nuncaVisito(self,categoria))
			self.premio(-10*categoria.millas())
	}



}

class Categoria {
	var property millas
}

class Sitio {
	
	var precio
	var property pais
	const visitantes = []
	const categoria = new Categoria(millas= 1)
	
	
	method puedeSerVisitado(turista) = 
		turista.puedePagar(self.importe(turista))
	
	method importe(turista) = precio
	
	method visitado(turista) {
		if(self.puedeSerVisitado(turista)){
			visitantes.add(turista)
			turista.pagar(self.importe(turista))
			self.darBonificacion(turista)
		}
	}
	
	method darBonificacion(turista) {}
	
	method cantidadVisitasMenores() = 
		visitantes.count{t=>t.menor()}
	
	method fueVisitadoPor(turista) = visitantes.contains(turista)
	
	method darMilla(turista){
		if(turista.prefiere(categoria))
			turista.premio(categoria.millas())
	}
}

class SitioInfantil inherits Sitio{
	
	override method puedeSerVisitado(turista) = 
		super(turista) &&
		turista.menor()
	
	override method darBonificacion(turista){ 
	 	turista.premio(10)
	 }
}

class SitioMayor inherits Sitio{
	var descuento
	
	override method importe(turista) = 
		if(turista.adultoMayor()) 
			precio*(1-descuento) 
		else 
			precio
	
}	