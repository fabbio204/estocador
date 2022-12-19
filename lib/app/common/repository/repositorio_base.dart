abstract class RepositorioBase<T> {
  Future<List<T>> listar(String intervalo);

  Future<void> salvar(String intervalo, String valor);

  Future<void> salvarConjunto(String intervalo, List<List<Object>> valor);
}
