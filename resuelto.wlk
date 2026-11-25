class Obra {
  const autor
  var estado
  const anioCreacion

  method modificarEstado(nuevoEstado) {
    estado = nuevoEstado
  }

  method nombreAutor() {
    return autor.nombre()
  }

  method valorBase()

  method valorTotal() {
    const aumentoAutor = autor.aumentoValor()
    return estado.modificarPrecio(self.valorBase() * aumentoAutor)
  }

  method restaurarCon(presupuesto) {
    estado.restauracionDe(self, presupuesto)
  }

  method seExpone() {
    return estado.puedeExponerse(self)
  }

  method esBarata() {
    return self.valorTotal() < 100000
  }
}

class Pintura inherits Obra {
  const atractivo

  override method valorBase() {
    return atractivo * self.periodoMultiplicador()
  }

  method periodoMultiplicador() {
    if (anioCreacion.between(1350, 1527)) {
      return 7
    } else if (anioCreacion.between(476, 1349)) {
      return 3
    } else {
      return 1
    }
  }
}

object galeria {
  var obras = #{}

  method autoresEntre(inicio, fin) {
    const obrasFiltradas = self.obrasEntre(inicio, fin)
    return obrasFiltradas.map({ o => o.nombreAutor() }).asSet()
  }

  method obrasEntre(inicio, fin) {
    return obras.filter({ o => o.anioCreacion().between(inicio, fin) })
  }

  method valorTotalDe(unAutor) {
    return self.obrasDe(unAutor).map({ o => o.valorTotal() }).sum()
  }

  method obrasDe(autor) {
    return obras.filter({ o => o.nombreAutor() == autor })
  }

  method laMasCara() {
    return self.obrasEnExposicion().sortedBy({ a, b => a.valorTotal() > b.valorTotal() }).first()
  }

  method obrasEnExposicion() {
    return obras.filter({ o => o.seExpone() })
  }
}

class Deteriorada {
  var puntosDeterioro

  method modificarPrecio(unValor) {
    return unValor - (puntosDeterioro / 10)
  }

  method restauracionDe(obra, presupuesto) {
    const costoRestauracion = 1000 * puntosDeterioro
    if (presupuesto >= costoRestauracion) {
      obra.modificarEstado(sanas)
    } else {
      obra.modificarEstado(arruinada)
    }
  }

  method puedeExponerse(obra) {
    return puntosDeterioro < 30 && obra.esBarata()
  }
}

object arruinada {
  method modificarPrecio(precio) {
    return precio * 0
  }

  method restauracionDe(obra, presupuesto) {
    throw new Exception(message = "No se puede restaurar una obra arruinada")
  }

  method puedeExponerse(o) {
    return false
  }
}

object sanas {
  method modificarPrecio(precio) {
    return precio
  }

  method restauracionDe(obra, presupuesto) {}

  method puedeExponerse(obra) {
    return true
  }
}
