class Gol{
	var	property jugador
	var property minuto
	var property penal
	var property adversario
}


class Pais{
	
	const nombre
	const goles = []
	const hinchas = []
	
	method hacerUnGol(jugador, minuto,adversario,penal) {
		const gol = new Gol(jugador = jugador,adversario = adversario, minuto = minuto, penal = penal)
		goles.add(gol)
		self.festejoDeHinchas(gol)
		adversario.tristezaDeHinchas()
	}
	
	method festejoDeHinchas(jugador) {
		hinchas.forEach{h=>h.festejoGol(jugador)} 
	}
	
	method tristezaDeHinchas() {
		hinchas.forEach{h=>h.tristezaGol()} 
	}	
	
	//Obtener los hinchas muy alegres de un país, que son aquellos cuya alegría sea mayor a un valor dado.
	method hinchasAlegres(valor) = hinchas.filter{h=>h.alegria()> valor}
	
	
	//Averiguar cuál es la cantidad total de goles que hizo argentina en todo el mundial
	method cantidadGoles() = goles.size()

	//La cantidad de jugadores que hayan hecho algún gol de penal
	method cantidadJugadoresPenalistas() = self.jugadores().count{j=>self.hizoGolDePenal(j)}

	method jugadores() = goles.map{g=>g.jugador()}.asSet()
			
	method hizoGolDePenal(jugador)= 
		goles.any{g=>g.jugador() == jugador}
		
	//El país al que argentina le hizo la mayor cantidad de goles
	method paisMasGoleado() = 
		self.paisesAdversarios().max{p=> self.cantidadGolesConvertidosA(p)}
	
	method paisesAdversarios() = goles.map{g=>g.adversario()}.asSet()

	method cantidadGolesConvertidosA(pais) =
		goles.count{g=>g.adversario() == pais}
		
}


object fifa{
	
	method formula(valor) = valor * 2
}

class Simpatizante {
	
	var property alegria
	
	method festejoGol(gol) {
		if(gol.minuto() <= 90)
			alegria += 1
		else
			alegria += fifa.formula(gol.minuto()-90)
	}
	
	method tristezaGol() {}
	
}

class Fanatico inherits Simpatizante{
	var nivel
	
	override method tristezaGol(){
		alegria -= nivel
		self.validarTristeza()
	}
	
	method validarTristeza() {
		if(alegria<0) throw new Exception(message="alegria negativa")
	}
	
	method viajar() {
		nivel = nivel + 10
	}
	
}

class Seguidor inherits Simpatizante{
	
	var property idolo
	
	override method festejoGol(gol) {
		super(gol)
		if (idolo == gol.jugador())
			alegria *=2
	}
}
