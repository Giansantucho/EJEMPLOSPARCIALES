// Parcial Objetos - Irina Maia Pérez Gribnicow
object plataforma {
	var property juegos = []
	
	method juegoMasCaro()
	{
		return juegos.max{j => j.precio()}
	}
	
	method modificarDescuento(juego, nuevoDescuento)
	{
		juego.descuento(nuevoDescuento)
	}
	
	method eliminarDescuento(juego)
	{
		juego.descuento(descuentoNulo)
	}
	
	method aniadirJuego(juego)
	{
		juegos.add(juego)
	}
	
	method removerJuego(juego)
	{
		juegos.remove(juego)
	}
	
	 ////////////////// PUNTO 2 //////////////////
	 method aplicarDescuentoPorcentual(nuevoPorcentaje)
	 {	
	 	if (nuevoPorcentaje > 1)
	 	{
	 		throw new Exception(message = "No se puede aplicar un descuento del mas del 100%")
	 	}
	 	const precioJuegoMasCaro = self.juegoMasCaro().precio()
	 	
	 	const juegosADescontar = juegos.filter{j => j.superaPrecio( 0.75 * precioJuegoMasCaro)}
	 	
	 	const nuevoDescuento = new DescuentoDirecto(porcentaje = nuevoPorcentaje)
	 	
	 	juegosADescontar.forEach{j => self.modificarDescuento(j, nuevoDescuento)}
	 }
	 
	 //////////////////// INTERNACIONALIZACIÓN ////////////////////
	 
	method juegoAptoParaMenoresEnPais(juego, pais)
	{
		return juego.aptoParaMenoresEnPais(pais)
	}
	
	method precioJuegoEnPais(juego, pais)
	{
		return pais.deDolaresAPesos(juego.precio())
	}
	
	method todosLosJuegosAptosEnPais(pais)
	{
		return juegos.filter{j => self.juegoAptoParaMenoresEnPais(j, pais)}
	}
	
	method promedioDeTodosLosJuegosAptosEnPais(pais)
	{
		const juegosAptos = self.todosLosJuegosAptosEnPais(pais)
		
		const cantidadJuegosAptos = juegosAptos.size()
		
		return juegosAptos.sum{x => x.precio()} / cantidadJuegosAptos
		
	}
	
	//////////////////////////////////// REVIEWS ////////////////////////////////////
	// PUNTO 3 //
	method hayAlgunJuegoGalardonado()
	{
		return juegos.any{x => x.sinCriticasNegativas() }
	}
}
class Juego {
	const property precioBase 
	var property descuento = descuentoNulo
	// contiene lenguaje inapropiado, situaciones de violencia o temáticas de adultos, etc.
	var property caracteristicas = []
	var property criticas = []
	
	////////////////// PUNTO 1 //////////////////
	method precio() {
		// El precio no puede ser menor a 0
		return (descuento.precio(self)).max(0)
	}
	
	method superaPrecio(precio) {
		return self.precio() > precio
	}
	
	//////////////// LEGISLACION ////////////////
	method contieneCaracteristica(caracteristica){
		return caracteristicas.contains(caracteristica)
	}
	
	method contieneAlgunaCaracteristica(listaCaracteristicas) {
		return listaCaracteristicas.any{x => self.contieneCaracteristica(x)}
	}
	
	method esViolento()
	{
		return self.contieneCaracteristica("violento")
	}
	
	method aptoParaMenoresEnPais(pais)
	{
		return !self.contieneAlgunaCaracteristica(pais.caracteristicasProhibidas())
	}
	//////////////////////////////////// REVIEWS ////////////////////////////////////
	// PUNTO 1//
	method recibirCritica(critica)
	{
		criticas.add(critica)
	}
	
	// PUNTO 2 //
	method tieneAlMenosNCantidadCriticasPositivas(n)
	{
		return criticas.filter{x => x.esPositiva()}.size() > n
	}
	
	// PUNTO 3 //
	method sinCriticasNegativas()
	{
		return criticas.all{x => x.esPositiva()}
	}
	
	// PUNTO 4 //
	method tieneCriticoLiterario()
	{
		return criticas.any{x => x.tieneTextoLargo()}
	}
}

////////////////// DESCUENTOS //////////////////
class DescuentoDirecto {
	// Valor del tipo 0.1, 0.5 ...
	var property porcentaje
	method precio(juego) {
		return juego.precioBase() - (porcentaje * juego.precioBase())
	}
}

class DescuentoFijo {
	const montoFijo
	method precio(juego)
	{
		const mitadPrecioOriginal = juego.precioBase() / 2
		return (juego.precioBase() - montoFijo).max(mitadPrecioOriginal)
	}	
}

class DescuentoGratis {
	method precio(juego) = 0
}

object descuentoNulo {
	method precio(juego) = juego.precioBase()
}

// DESCUENTO INVENTADO //
class DescuentoDirectoSoloParaJuegosNoViolentos inherits DescuentoDirecto {
	override method precio(juego)
	{
		if (juego.esViolento()) {
			return juego.precioBase()
		}
		return super(juego)
	}
}

//////////////////////// INTERNACIONALIZACIÓN //////////////////////////////////// 
class Pais {
	var property conversionDolares
	var property caracteristicasProhibidas = [] 
	
	method deDolaresAPesos(precioEnDolares)
	{
		return precioEnDolares * conversionDolares
	}
}
//////////////////////////////////// REVIEWS ////////////////////////////////////
class Critica {
	var property texto
	var property positiva
	method esPositiva() 
	{
		return positiva
	}
	
	// PUNTO 4 //
	method tieneTextoLargo()
	{
		return texto.words().size() > 100
	}
}

object positiva {
	method textoUsuario() = "SI"
	method esPositiva() = true
}

object negativa {
	method textoUsuario() = "NO"
	method esPositiva() = false
}

class Critico {
	method daCriticaPositiva(juego)
	
	method textoCritica()
	
	// PUNTO 1 //
	method criticar(juego) 
	{
		const unaCritica = new Critica(texto = self.textoCritica(), positiva = self.daCriticaPositiva(juego))
		juego.recibirCritica(unaCritica)
	}
}

class Usuario inherits Critico{
	// positiva o negativa
	var property posicion
	override method textoCritica() = posicion.textoUsuario()
	override method daCriticaPositiva(juego) = posicion.esPositiva()
}

class CriticoPago  inherits Critico{
	const juegosQueLePagaron = []
	const palabrasRandomDeCriticos = ["divertido", "aburrido", "feo", "juego", "robo"]
	//  Son positivos cuando el juego está en la lista de juegos que le pagaron.
	override method daCriticaPositiva(juego)
	{
		return juegosQueLePagaron.contains(juego)
	}
	
	override method textoCritica()
	{
		return palabrasRandomDeCriticos.anyOne()
	}
	
	method recibirPagoDeJuego(juego)
	{
		juegosQueLePagaron.add(juego)
	}
	
	method dejarDeRecibirPagoDeJuego(juego)
	{
		juegosQueLePagaron.remove(juego)
	}
}

class Revista inherits Critico {
	const criticos = []
	// son positivas si la mayoría de los críticos que la conforman califican positivamente 
	override method daCriticaPositiva(juego)
	{
		return self.mayoriaCriticosDaCriticaPositiva(juego)
	}
	
	method mayoriaCriticosDaCriticaPositiva(juego) {
		const criticosQueDanCriticaPositiva = self.criticosQueDanCriticaPositiva(juego)
		return criticosQueDanCriticaPositiva.size() > criticos.size() / 2
	}
	
	method criticosQueDanCriticaPositiva(juego)
	{
		return criticos.filter{x => x.daCriticaPositiva(juego) }
	}
	
	// El texto de la crítica es la concatenación de los textos de los críticos.
	override method textoCritica() 
	{	
		return criticos.map{x => x.textoCritica()}
	}
	
	// Una revista puede incorporar o perder críticos.
	method incorporarCritico(critico)
	{
		criticos.add(critico)
	}
	
	method removerCritico(critico)
	{
		criticos.remove(critico)
	}

}

/*
////////////////////////// TEORIA //////////////////////////
Justificar la utilidad de la herencia en la resolución, o el motivo de no haberla utilizado.

* En mi resolución fui cambiando la manera de resolver según los requerimientos. En el punto 1 [DESCUENTOS] decidí no utilizar herencia
 * y utilizar composición en su lugar. Esto se debe que, aunque los descuentos tengan ciertas características en común, me pareció más apropiado
 * hacerlo de esta manera debido a que el descuento del juego no es algo fijo y puede ser cambiado, entonces el cálculo del precio del juego lo delegé
 * al descuento que tuviese en ese momento, sin importar cual fuese.
 * Por otro lado, en el punto 3 [REVIEWS] si decidí utilzar herencia porque me pareció que los tres tipos de críticos posibles podrían ser subcalses
 * de la clase Crítico, ya que los tres tenian puntos en común. Por ejemplo, la manera en la que dan una crítica es igual para todos los casos, por lo
 * tanto el método criticar está definida en la clase padre, mientras que la manera en la que generan el texto de la crítica es diferente para cada 
 * crítico, por lo tanto cada forma está definida en cada subclase. En la clase padre este método está vacío ya que es una clase abstracta, no puede
 * instanciarse ya que no puede haber críticos genéricos.
 * 
Para pensar: ¿qué pasaría si en una revista, entre sus críticos, hay a su vez una revista?

El código funcionaría correctamente, debido a que revista es polimórfica consigo misma, es decir, todos los métodos que aplica en sus integrantes para
* definir distintas características de si misma pueden ser aplicados a su vez en si misma.
* Un ejemplo de esto sería: Una revista esta compuesta de un usuario y otra revista que a su vez está compuesta por dos críticos.
* Para verificar si la revista da una crítica positiva se utiliza el método daCriticaPositiva, el cual se fija si la mayoría de sus
* integrantes den una crítica positiva.
* Primero verifica que el usuario de una crítica positiva haciendo que el usuario utilize su propio método daCriticaPositiva
* Luego verifica que la revista que la compone de una crítica positiva.
* Para esto, la revista que la compone utiliza su método daCriticaPositiva, que a su vez se fija que la mayoría de sus integrantes den
*  una crítica positiva, una vez hecho esto la revista "exterior" va a saber cual es la postura de la crítica de la revista "interior" y a su vez
* definir su propia postura en base a si hay mayoria negativa o positiva.
* */