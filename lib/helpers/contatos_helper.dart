import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
final String idColumn = 'idColumn';
final String nomeColumn = 'nomeColumn';
final String emailColumn = 'emailColumn';
final String telefoneColumn = 'telefoneColumn';
final String fotoColumn = 'fotoColumn';
final String contatosTable = "contatosTable";

Database _db;

// Essa classe não poderá ter várias instâncias por isso é utilizado o padrão Singleton (Static = Variável da minha classe. Final = Não vai ser alterável)
class ContatosHelper {

  // Quando eu declaro a minha classe eu crio um objeto dela mesmo (_instance)
  static final ContatosHelper _instance = ContatosHelper.internal();
  factory ContatosHelper() => _instance;
  ContatosHelper.internal();

  Future<Database> get db async {
   if(_db != null) {
     return _db;
   } else {
     _db = await initDb();
     return _db;
   }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    // Monta o nome do arquivo do banco de dados
    final path = join(databasesPath, 'contados.db');
    return openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $contatosTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT, $telefoneColumn TEXT, $fotoColumn TEXT)"
      );
    });
  }

  Future<Database> closeDb() async {
    Database dbContato = await db;
    dbContato.close();
  }

  Future<List> getAllContato(int id) async {
    Database dbContato = await db;
    List<Map> maps = await dbContato.rawQuery("SELECT * FROM $contatosTable");
    List<Contato> listaContatos = List();
    // Para cada mapa da minha lista de mapas eu pego ele tranformo ele em um contato e incluo na lista
    for (Map m in maps) {
      listaContatos.add(Contato.fromMap(m));
    }
    return listaContatos;
  }

  // Retorna a quantidade de contatos
  Future<int> getTamanhoLista() async {
    Database dbContato = await db;
    return Sqflite.firstIntValue(await dbContato.rawQuery("SELECT COUNT(*) FROM $contatosTable"));
  }

  Future<Contato> getContato(int id) async {
    Database dbContato = await db;
    List<Map> maps = await dbContato.query(contatosTable,
        columns: [idColumn, nomeColumn, emailColumn, telefoneColumn, fotoColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0) {
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Contato> salvaContato (Contato contato) async {
    Database dbContato = await db;
    contato.id = await dbContato.insert(contatosTable, contato.toMap());
    return contato;
  }

  Future<int> deletaContato(int id) async {
    Database dbContato = await db;
    // Retorna um inteiro
    return await dbContato.delete(contatosTable, where: "$idColumn = ?", whereArgs: [id]);
  }
  
  Future<int>atualizaContato (Contato contato) async {
    Database dbContato = await db;
    // Retorna um inteiro
    return await dbContato.update(contatosTable, contato.toMap(), where: "$idColumn = ?", whereArgs: [contato.id]);
  }

}

class Contato {
  int id;
  String nome;
  String email;
  String telefone;
  String foto;

  // Retorna os valores do Map
  // Construtor que recepe um map para que quando for armazenado os dados nos iremos armazena-los em formato de Map. E obter os dados os dados precisamos recupear este Map de volta (recebeo os dados do meu contato em um map e coloco os dados em seus campos)
  Contato.fromMap(Map map){
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    telefone = map[ telefoneColumn];
    foto = map[fotoColumn];
  }

  // Transforma os dados em Map
  Map toMap () {
    /* String vai ter o nome da coluna (idColumn, nomeColumn, etc) e dynamic vai ter o dado(id, nome, etc)

      Igual a

      Map<String, dynamic> contato = Map();
      contato[nomeColumn] = nome;
      contato[emailColumn] = email;
      contato[telefoneColumn] = telefone;
      contato[fotoColumn] = foto;
      return contato;

    */
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone,
      fotoColumn: foto
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  // Toda classe possui implementado o 'toString' então é possível fazer print(contato).
  @override
  String toString() {
    return "Contato(id $id,  nome: $nome, email: $email, telefone: $telefone, foto: $foto)";
  }

}

