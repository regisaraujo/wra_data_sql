import 'package:postgres/postgres.dart';

class PostgresDB {
  String _host = "";
  String _database = "";
  String _user = "";
  String _pass = "";
  bool _remote = false;
  Map<String, dynamic> _scriptDB = {};

  Map<String, dynamic> get script => _scriptDB;
  set script(value) => _scriptDB = value;

  bool get remote => _remote;
  set remote(value) => _remote = value;

  String get host => _host;
  set host(value) => _host = value;

  String get user => _user;
  set user(value) => _user = value;

  String get pass => _pass;
  set pass(value) => _pass = value;

  String get database => _database;
  set database(value) => _database = value;

  late Connection conn;

  PostgresDB({
    required host,
    required database,
    required user,
    required pass,
    required remote,
    Map<String, dynamic>? script,
  })  : _host = host ?? "localhost",
        _database = database ?? "worksoft",
        _user = user ?? "postgres",
        _pass = pass ?? "M3l80urn3",
        _remote = remote ?? false,
        _scriptDB = script ?? {};

  conexao() async {
    return await Connection.open(
      Endpoint(
        host: host,
        port: 5432,
        database: database,
        username: user,
        password: pass,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
  }
}
