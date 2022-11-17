class Gol{
	const minuto
	var property adversario
	var property penal
	
}


class Jugador{
	const goles = []
	
	method hacerUnGol(minuto,adversario,penal) {
		goles.add(new Gol(adversario = adversario, minuto = minuto, penal = penal))
	}
	
	method cantGoles() = goles.size()
	
	method hizoGolDePenal() = goles.any{g => g.esDePenal()}
	
	method paisesConGoles() = goles.map{g => g.adversario()}
	
	method golesConvertidosA(equipo) = goles.filter{g => g.adversarios() == equipo}
	
}

object seleccion{
	const jugadores = []
	
	method agregarJugador(jugador) = jugadores.add(jugador)
	
	method cantGoles(){
		return jugadores.sum{j => j.cantGoles()}
	}
	
	method jugadoresQueHicieronPenal(){
		jugadores.count{j => j.hizoGolDePenal()}
	}
	
	method paisMasGoleado(){
		return self.equiposAdversariosGoleados()
		.max{equipo => self.cantGolesCovertidosA(equipo)}
		}
		
	method equiposAdversariosGoleados(){
		const paises = #{}
		jugadores.forEach{j=>paises.addAll(j.paisesConGoles())}
		return paises
		}
	
	method cantGolesCovertidosA(equipo){
		return jugadores.sum{j => j.golesConvertidosA(equipo)}
	}
	
}