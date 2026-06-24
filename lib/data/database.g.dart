// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccueillantsTable extends Accueillants
    with TableInfo<$AccueillantsTable, Accueillant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccueillantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
    'prenom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nbPlacesMeta = const VerificationMeta(
    'nbPlaces',
  );
  @override
  late final GeneratedColumn<int> nbPlaces = GeneratedColumn<int>(
    'nb_places',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _restrictionSexeMeta = const VerificationMeta(
    'restrictionSexe',
  );
  @override
  late final GeneratedColumn<String> restrictionSexe = GeneratedColumn<String>(
    'restriction_sexe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(restrictionAucune),
  );
  static const VerificationMeta _ageMinMeta = const VerificationMeta('ageMin');
  @override
  late final GeneratedColumn<int> ageMin = GeneratedColumn<int>(
    'age_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMaxMeta = const VerificationMeta('ageMax');
  @override
  late final GeneratedColumn<int> ageMax = GeneratedColumn<int>(
    'age_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _agrementEcheanceMeta = const VerificationMeta(
    'agrementEcheance',
  );
  @override
  late final GeneratedColumn<DateTime> agrementEcheance =
      GeneratedColumn<DateTime>(
        'agrement_echeance',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nom,
    prenom,
    nbPlaces,
    restrictionSexe,
    ageMin,
    ageMax,
    agrementEcheance,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accueillants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Accueillant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(
        _prenomMeta,
        prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta),
      );
    }
    if (data.containsKey('nb_places')) {
      context.handle(
        _nbPlacesMeta,
        nbPlaces.isAcceptableOrUnknown(data['nb_places']!, _nbPlacesMeta),
      );
    }
    if (data.containsKey('restriction_sexe')) {
      context.handle(
        _restrictionSexeMeta,
        restrictionSexe.isAcceptableOrUnknown(
          data['restriction_sexe']!,
          _restrictionSexeMeta,
        ),
      );
    }
    if (data.containsKey('age_min')) {
      context.handle(
        _ageMinMeta,
        ageMin.isAcceptableOrUnknown(data['age_min']!, _ageMinMeta),
      );
    }
    if (data.containsKey('age_max')) {
      context.handle(
        _ageMaxMeta,
        ageMax.isAcceptableOrUnknown(data['age_max']!, _ageMaxMeta),
      );
    }
    if (data.containsKey('agrement_echeance')) {
      context.handle(
        _agrementEcheanceMeta,
        agrementEcheance.isAcceptableOrUnknown(
          data['agrement_echeance']!,
          _agrementEcheanceMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Accueillant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Accueillant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      prenom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom'],
      )!,
      nbPlaces: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nb_places'],
      )!,
      restrictionSexe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restriction_sexe'],
      )!,
      ageMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_min'],
      ),
      ageMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_max'],
      ),
      agrementEcheance: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}agrement_echeance'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $AccueillantsTable createAlias(String alias) {
    return $AccueillantsTable(attachedDatabase, alias);
  }
}

class Accueillant extends DataClass implements Insertable<Accueillant> {
  final int id;
  final String nom;
  final String prenom;
  final int nbPlaces;
  final String restrictionSexe;
  final int? ageMin;
  final int? ageMax;
  final DateTime? agrementEcheance;
  final String? notes;
  const Accueillant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.nbPlaces,
    required this.restrictionSexe,
    this.ageMin,
    this.ageMax,
    this.agrementEcheance,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['prenom'] = Variable<String>(prenom);
    map['nb_places'] = Variable<int>(nbPlaces);
    map['restriction_sexe'] = Variable<String>(restrictionSexe);
    if (!nullToAbsent || ageMin != null) {
      map['age_min'] = Variable<int>(ageMin);
    }
    if (!nullToAbsent || ageMax != null) {
      map['age_max'] = Variable<int>(ageMax);
    }
    if (!nullToAbsent || agrementEcheance != null) {
      map['agrement_echeance'] = Variable<DateTime>(agrementEcheance);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  AccueillantsCompanion toCompanion(bool nullToAbsent) {
    return AccueillantsCompanion(
      id: Value(id),
      nom: Value(nom),
      prenom: Value(prenom),
      nbPlaces: Value(nbPlaces),
      restrictionSexe: Value(restrictionSexe),
      ageMin: ageMin == null && nullToAbsent
          ? const Value.absent()
          : Value(ageMin),
      ageMax: ageMax == null && nullToAbsent
          ? const Value.absent()
          : Value(ageMax),
      agrementEcheance: agrementEcheance == null && nullToAbsent
          ? const Value.absent()
          : Value(agrementEcheance),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Accueillant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Accueillant(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      prenom: serializer.fromJson<String>(json['prenom']),
      nbPlaces: serializer.fromJson<int>(json['nbPlaces']),
      restrictionSexe: serializer.fromJson<String>(json['restrictionSexe']),
      ageMin: serializer.fromJson<int?>(json['ageMin']),
      ageMax: serializer.fromJson<int?>(json['ageMax']),
      agrementEcheance: serializer.fromJson<DateTime?>(
        json['agrementEcheance'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'prenom': serializer.toJson<String>(prenom),
      'nbPlaces': serializer.toJson<int>(nbPlaces),
      'restrictionSexe': serializer.toJson<String>(restrictionSexe),
      'ageMin': serializer.toJson<int?>(ageMin),
      'ageMax': serializer.toJson<int?>(ageMax),
      'agrementEcheance': serializer.toJson<DateTime?>(agrementEcheance),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Accueillant copyWith({
    int? id,
    String? nom,
    String? prenom,
    int? nbPlaces,
    String? restrictionSexe,
    Value<int?> ageMin = const Value.absent(),
    Value<int?> ageMax = const Value.absent(),
    Value<DateTime?> agrementEcheance = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Accueillant(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    prenom: prenom ?? this.prenom,
    nbPlaces: nbPlaces ?? this.nbPlaces,
    restrictionSexe: restrictionSexe ?? this.restrictionSexe,
    ageMin: ageMin.present ? ageMin.value : this.ageMin,
    ageMax: ageMax.present ? ageMax.value : this.ageMax,
    agrementEcheance: agrementEcheance.present
        ? agrementEcheance.value
        : this.agrementEcheance,
    notes: notes.present ? notes.value : this.notes,
  );
  Accueillant copyWithCompanion(AccueillantsCompanion data) {
    return Accueillant(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      prenom: data.prenom.present ? data.prenom.value : this.prenom,
      nbPlaces: data.nbPlaces.present ? data.nbPlaces.value : this.nbPlaces,
      restrictionSexe: data.restrictionSexe.present
          ? data.restrictionSexe.value
          : this.restrictionSexe,
      ageMin: data.ageMin.present ? data.ageMin.value : this.ageMin,
      ageMax: data.ageMax.present ? data.ageMax.value : this.ageMax,
      agrementEcheance: data.agrementEcheance.present
          ? data.agrementEcheance.value
          : this.agrementEcheance,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Accueillant(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('nbPlaces: $nbPlaces, ')
          ..write('restrictionSexe: $restrictionSexe, ')
          ..write('ageMin: $ageMin, ')
          ..write('ageMax: $ageMax, ')
          ..write('agrementEcheance: $agrementEcheance, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nom,
    prenom,
    nbPlaces,
    restrictionSexe,
    ageMin,
    ageMax,
    agrementEcheance,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Accueillant &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.prenom == this.prenom &&
          other.nbPlaces == this.nbPlaces &&
          other.restrictionSexe == this.restrictionSexe &&
          other.ageMin == this.ageMin &&
          other.ageMax == this.ageMax &&
          other.agrementEcheance == this.agrementEcheance &&
          other.notes == this.notes);
}

class AccueillantsCompanion extends UpdateCompanion<Accueillant> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> prenom;
  final Value<int> nbPlaces;
  final Value<String> restrictionSexe;
  final Value<int?> ageMin;
  final Value<int?> ageMax;
  final Value<DateTime?> agrementEcheance;
  final Value<String?> notes;
  const AccueillantsCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.prenom = const Value.absent(),
    this.nbPlaces = const Value.absent(),
    this.restrictionSexe = const Value.absent(),
    this.ageMin = const Value.absent(),
    this.ageMax = const Value.absent(),
    this.agrementEcheance = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AccueillantsCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    this.prenom = const Value.absent(),
    this.nbPlaces = const Value.absent(),
    this.restrictionSexe = const Value.absent(),
    this.ageMin = const Value.absent(),
    this.ageMax = const Value.absent(),
    this.agrementEcheance = const Value.absent(),
    this.notes = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Accueillant> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? prenom,
    Expression<int>? nbPlaces,
    Expression<String>? restrictionSexe,
    Expression<int>? ageMin,
    Expression<int>? ageMax,
    Expression<DateTime>? agrementEcheance,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (nbPlaces != null) 'nb_places': nbPlaces,
      if (restrictionSexe != null) 'restriction_sexe': restrictionSexe,
      if (ageMin != null) 'age_min': ageMin,
      if (ageMax != null) 'age_max': ageMax,
      if (agrementEcheance != null) 'agrement_echeance': agrementEcheance,
      if (notes != null) 'notes': notes,
    });
  }

  AccueillantsCompanion copyWith({
    Value<int>? id,
    Value<String>? nom,
    Value<String>? prenom,
    Value<int>? nbPlaces,
    Value<String>? restrictionSexe,
    Value<int?>? ageMin,
    Value<int?>? ageMax,
    Value<DateTime?>? agrementEcheance,
    Value<String?>? notes,
  }) {
    return AccueillantsCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      nbPlaces: nbPlaces ?? this.nbPlaces,
      restrictionSexe: restrictionSexe ?? this.restrictionSexe,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      agrementEcheance: agrementEcheance ?? this.agrementEcheance,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (nbPlaces.present) {
      map['nb_places'] = Variable<int>(nbPlaces.value);
    }
    if (restrictionSexe.present) {
      map['restriction_sexe'] = Variable<String>(restrictionSexe.value);
    }
    if (ageMin.present) {
      map['age_min'] = Variable<int>(ageMin.value);
    }
    if (ageMax.present) {
      map['age_max'] = Variable<int>(ageMax.value);
    }
    if (agrementEcheance.present) {
      map['agrement_echeance'] = Variable<DateTime>(agrementEcheance.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccueillantsCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('nbPlaces: $nbPlaces, ')
          ..write('restrictionSexe: $restrictionSexe, ')
          ..write('ageMin: $ageMin, ')
          ..write('ageMax: $ageMax, ')
          ..write('agrementEcheance: $agrementEcheance, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $FratriesTable extends Fratries with TableInfo<$FratriesTable, Fratrie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FratriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regroupementMeta = const VerificationMeta(
    'regroupement',
  );
  @override
  late final GeneratedColumn<String> regroupement = GeneratedColumn<String>(
    'regroupement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(regroupementEnsemble),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nom, regroupement];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fratries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Fratrie> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('regroupement')) {
      context.handle(
        _regroupementMeta,
        regroupement.isAcceptableOrUnknown(
          data['regroupement']!,
          _regroupementMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Fratrie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Fratrie(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      regroupement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regroupement'],
      )!,
    );
  }

  @override
  $FratriesTable createAlias(String alias) {
    return $FratriesTable(attachedDatabase, alias);
  }
}

class Fratrie extends DataClass implements Insertable<Fratrie> {
  final int id;
  final String nom;
  final String regroupement;
  const Fratrie({
    required this.id,
    required this.nom,
    required this.regroupement,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['regroupement'] = Variable<String>(regroupement);
    return map;
  }

  FratriesCompanion toCompanion(bool nullToAbsent) {
    return FratriesCompanion(
      id: Value(id),
      nom: Value(nom),
      regroupement: Value(regroupement),
    );
  }

  factory Fratrie.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Fratrie(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      regroupement: serializer.fromJson<String>(json['regroupement']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'regroupement': serializer.toJson<String>(regroupement),
    };
  }

  Fratrie copyWith({int? id, String? nom, String? regroupement}) => Fratrie(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    regroupement: regroupement ?? this.regroupement,
  );
  Fratrie copyWithCompanion(FratriesCompanion data) {
    return Fratrie(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      regroupement: data.regroupement.present
          ? data.regroupement.value
          : this.regroupement,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Fratrie(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('regroupement: $regroupement')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nom, regroupement);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Fratrie &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.regroupement == this.regroupement);
}

class FratriesCompanion extends UpdateCompanion<Fratrie> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> regroupement;
  const FratriesCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.regroupement = const Value.absent(),
  });
  FratriesCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    this.regroupement = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Fratrie> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? regroupement,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (regroupement != null) 'regroupement': regroupement,
    });
  }

  FratriesCompanion copyWith({
    Value<int>? id,
    Value<String>? nom,
    Value<String>? regroupement,
  }) {
    return FratriesCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      regroupement: regroupement ?? this.regroupement,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (regroupement.present) {
      map['regroupement'] = Variable<String>(regroupement.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FratriesCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('regroupement: $regroupement')
          ..write(')'))
        .toString();
  }
}

class $EnfantsTable extends Enfants with TableInfo<$EnfantsTable, Enfant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnfantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
    'prenom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sexeMeta = const VerificationMeta('sexe');
  @override
  late final GeneratedColumn<String> sexe = GeneratedColumn<String>(
    'sexe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(sexeGarcon),
  );
  static const VerificationMeta _dateNaissanceMeta = const VerificationMeta(
    'dateNaissance',
  );
  @override
  late final GeneratedColumn<DateTime> dateNaissance =
      GeneratedColumn<DateTime>(
        'date_naissance',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _afHabituelIdMeta = const VerificationMeta(
    'afHabituelId',
  );
  @override
  late final GeneratedColumn<int> afHabituelId = GeneratedColumn<int>(
    'af_habituel_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accueillants (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _fratrieIdMeta = const VerificationMeta(
    'fratrieId',
  );
  @override
  late final GeneratedColumn<int> fratrieId = GeneratedColumn<int>(
    'fratrie_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fratries (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _santeMeta = const VerificationMeta('sante');
  @override
  late final GeneratedColumn<String> sante = GeneratedColumn<String>(
    'sante',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactUrgenceMeta = const VerificationMeta(
    'contactUrgence',
  );
  @override
  late final GeneratedColumn<String> contactUrgence = GeneratedColumn<String>(
    'contact_urgence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nom,
    prenom,
    sexe,
    dateNaissance,
    afHabituelId,
    fratrieId,
    sante,
    contactUrgence,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'enfants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Enfant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(
        _prenomMeta,
        prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta),
      );
    }
    if (data.containsKey('sexe')) {
      context.handle(
        _sexeMeta,
        sexe.isAcceptableOrUnknown(data['sexe']!, _sexeMeta),
      );
    }
    if (data.containsKey('date_naissance')) {
      context.handle(
        _dateNaissanceMeta,
        dateNaissance.isAcceptableOrUnknown(
          data['date_naissance']!,
          _dateNaissanceMeta,
        ),
      );
    }
    if (data.containsKey('af_habituel_id')) {
      context.handle(
        _afHabituelIdMeta,
        afHabituelId.isAcceptableOrUnknown(
          data['af_habituel_id']!,
          _afHabituelIdMeta,
        ),
      );
    }
    if (data.containsKey('fratrie_id')) {
      context.handle(
        _fratrieIdMeta,
        fratrieId.isAcceptableOrUnknown(data['fratrie_id']!, _fratrieIdMeta),
      );
    }
    if (data.containsKey('sante')) {
      context.handle(
        _santeMeta,
        sante.isAcceptableOrUnknown(data['sante']!, _santeMeta),
      );
    }
    if (data.containsKey('contact_urgence')) {
      context.handle(
        _contactUrgenceMeta,
        contactUrgence.isAcceptableOrUnknown(
          data['contact_urgence']!,
          _contactUrgenceMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Enfant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Enfant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      prenom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom'],
      )!,
      sexe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sexe'],
      )!,
      dateNaissance: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_naissance'],
      ),
      afHabituelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}af_habituel_id'],
      ),
      fratrieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fratrie_id'],
      ),
      sante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sante'],
      ),
      contactUrgence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_urgence'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $EnfantsTable createAlias(String alias) {
    return $EnfantsTable(attachedDatabase, alias);
  }
}

class Enfant extends DataClass implements Insertable<Enfant> {
  final int id;
  final String nom;
  final String prenom;
  final String sexe;
  final DateTime? dateNaissance;
  final int? afHabituelId;
  final int? fratrieId;
  final String? sante;
  final String? contactUrgence;
  final String? notes;
  const Enfant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.sexe,
    this.dateNaissance,
    this.afHabituelId,
    this.fratrieId,
    this.sante,
    this.contactUrgence,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['prenom'] = Variable<String>(prenom);
    map['sexe'] = Variable<String>(sexe);
    if (!nullToAbsent || dateNaissance != null) {
      map['date_naissance'] = Variable<DateTime>(dateNaissance);
    }
    if (!nullToAbsent || afHabituelId != null) {
      map['af_habituel_id'] = Variable<int>(afHabituelId);
    }
    if (!nullToAbsent || fratrieId != null) {
      map['fratrie_id'] = Variable<int>(fratrieId);
    }
    if (!nullToAbsent || sante != null) {
      map['sante'] = Variable<String>(sante);
    }
    if (!nullToAbsent || contactUrgence != null) {
      map['contact_urgence'] = Variable<String>(contactUrgence);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  EnfantsCompanion toCompanion(bool nullToAbsent) {
    return EnfantsCompanion(
      id: Value(id),
      nom: Value(nom),
      prenom: Value(prenom),
      sexe: Value(sexe),
      dateNaissance: dateNaissance == null && nullToAbsent
          ? const Value.absent()
          : Value(dateNaissance),
      afHabituelId: afHabituelId == null && nullToAbsent
          ? const Value.absent()
          : Value(afHabituelId),
      fratrieId: fratrieId == null && nullToAbsent
          ? const Value.absent()
          : Value(fratrieId),
      sante: sante == null && nullToAbsent
          ? const Value.absent()
          : Value(sante),
      contactUrgence: contactUrgence == null && nullToAbsent
          ? const Value.absent()
          : Value(contactUrgence),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Enfant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Enfant(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      prenom: serializer.fromJson<String>(json['prenom']),
      sexe: serializer.fromJson<String>(json['sexe']),
      dateNaissance: serializer.fromJson<DateTime?>(json['dateNaissance']),
      afHabituelId: serializer.fromJson<int?>(json['afHabituelId']),
      fratrieId: serializer.fromJson<int?>(json['fratrieId']),
      sante: serializer.fromJson<String?>(json['sante']),
      contactUrgence: serializer.fromJson<String?>(json['contactUrgence']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'prenom': serializer.toJson<String>(prenom),
      'sexe': serializer.toJson<String>(sexe),
      'dateNaissance': serializer.toJson<DateTime?>(dateNaissance),
      'afHabituelId': serializer.toJson<int?>(afHabituelId),
      'fratrieId': serializer.toJson<int?>(fratrieId),
      'sante': serializer.toJson<String?>(sante),
      'contactUrgence': serializer.toJson<String?>(contactUrgence),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Enfant copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? sexe,
    Value<DateTime?> dateNaissance = const Value.absent(),
    Value<int?> afHabituelId = const Value.absent(),
    Value<int?> fratrieId = const Value.absent(),
    Value<String?> sante = const Value.absent(),
    Value<String?> contactUrgence = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Enfant(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    prenom: prenom ?? this.prenom,
    sexe: sexe ?? this.sexe,
    dateNaissance: dateNaissance.present
        ? dateNaissance.value
        : this.dateNaissance,
    afHabituelId: afHabituelId.present ? afHabituelId.value : this.afHabituelId,
    fratrieId: fratrieId.present ? fratrieId.value : this.fratrieId,
    sante: sante.present ? sante.value : this.sante,
    contactUrgence: contactUrgence.present
        ? contactUrgence.value
        : this.contactUrgence,
    notes: notes.present ? notes.value : this.notes,
  );
  Enfant copyWithCompanion(EnfantsCompanion data) {
    return Enfant(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      prenom: data.prenom.present ? data.prenom.value : this.prenom,
      sexe: data.sexe.present ? data.sexe.value : this.sexe,
      dateNaissance: data.dateNaissance.present
          ? data.dateNaissance.value
          : this.dateNaissance,
      afHabituelId: data.afHabituelId.present
          ? data.afHabituelId.value
          : this.afHabituelId,
      fratrieId: data.fratrieId.present ? data.fratrieId.value : this.fratrieId,
      sante: data.sante.present ? data.sante.value : this.sante,
      contactUrgence: data.contactUrgence.present
          ? data.contactUrgence.value
          : this.contactUrgence,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Enfant(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('sexe: $sexe, ')
          ..write('dateNaissance: $dateNaissance, ')
          ..write('afHabituelId: $afHabituelId, ')
          ..write('fratrieId: $fratrieId, ')
          ..write('sante: $sante, ')
          ..write('contactUrgence: $contactUrgence, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nom,
    prenom,
    sexe,
    dateNaissance,
    afHabituelId,
    fratrieId,
    sante,
    contactUrgence,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Enfant &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.prenom == this.prenom &&
          other.sexe == this.sexe &&
          other.dateNaissance == this.dateNaissance &&
          other.afHabituelId == this.afHabituelId &&
          other.fratrieId == this.fratrieId &&
          other.sante == this.sante &&
          other.contactUrgence == this.contactUrgence &&
          other.notes == this.notes);
}

class EnfantsCompanion extends UpdateCompanion<Enfant> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> prenom;
  final Value<String> sexe;
  final Value<DateTime?> dateNaissance;
  final Value<int?> afHabituelId;
  final Value<int?> fratrieId;
  final Value<String?> sante;
  final Value<String?> contactUrgence;
  final Value<String?> notes;
  const EnfantsCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.prenom = const Value.absent(),
    this.sexe = const Value.absent(),
    this.dateNaissance = const Value.absent(),
    this.afHabituelId = const Value.absent(),
    this.fratrieId = const Value.absent(),
    this.sante = const Value.absent(),
    this.contactUrgence = const Value.absent(),
    this.notes = const Value.absent(),
  });
  EnfantsCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    this.prenom = const Value.absent(),
    this.sexe = const Value.absent(),
    this.dateNaissance = const Value.absent(),
    this.afHabituelId = const Value.absent(),
    this.fratrieId = const Value.absent(),
    this.sante = const Value.absent(),
    this.contactUrgence = const Value.absent(),
    this.notes = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Enfant> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? prenom,
    Expression<String>? sexe,
    Expression<DateTime>? dateNaissance,
    Expression<int>? afHabituelId,
    Expression<int>? fratrieId,
    Expression<String>? sante,
    Expression<String>? contactUrgence,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (sexe != null) 'sexe': sexe,
      if (dateNaissance != null) 'date_naissance': dateNaissance,
      if (afHabituelId != null) 'af_habituel_id': afHabituelId,
      if (fratrieId != null) 'fratrie_id': fratrieId,
      if (sante != null) 'sante': sante,
      if (contactUrgence != null) 'contact_urgence': contactUrgence,
      if (notes != null) 'notes': notes,
    });
  }

  EnfantsCompanion copyWith({
    Value<int>? id,
    Value<String>? nom,
    Value<String>? prenom,
    Value<String>? sexe,
    Value<DateTime?>? dateNaissance,
    Value<int?>? afHabituelId,
    Value<int?>? fratrieId,
    Value<String?>? sante,
    Value<String?>? contactUrgence,
    Value<String?>? notes,
  }) {
    return EnfantsCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      sexe: sexe ?? this.sexe,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      afHabituelId: afHabituelId ?? this.afHabituelId,
      fratrieId: fratrieId ?? this.fratrieId,
      sante: sante ?? this.sante,
      contactUrgence: contactUrgence ?? this.contactUrgence,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (sexe.present) {
      map['sexe'] = Variable<String>(sexe.value);
    }
    if (dateNaissance.present) {
      map['date_naissance'] = Variable<DateTime>(dateNaissance.value);
    }
    if (afHabituelId.present) {
      map['af_habituel_id'] = Variable<int>(afHabituelId.value);
    }
    if (fratrieId.present) {
      map['fratrie_id'] = Variable<int>(fratrieId.value);
    }
    if (sante.present) {
      map['sante'] = Variable<String>(sante.value);
    }
    if (contactUrgence.present) {
      map['contact_urgence'] = Variable<String>(contactUrgence.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnfantsCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('sexe: $sexe, ')
          ..write('dateNaissance: $dateNaissance, ')
          ..write('afHabituelId: $afHabituelId, ')
          ..write('fratrieId: $fratrieId, ')
          ..write('sante: $sante, ')
          ..write('contactUrgence: $contactUrgence, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $DisponibilitesAccueilTable extends DisponibilitesAccueil
    with TableInfo<$DisponibilitesAccueilTable, DisponibiliteAccueil> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DisponibilitesAccueilTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accueillantIdMeta = const VerificationMeta(
    'accueillantId',
  );
  @override
  late final GeneratedColumn<int> accueillantId = GeneratedColumn<int>(
    'accueillant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accueillants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _debutMeta = const VerificationMeta('debut');
  @override
  late final GeneratedColumn<DateTime> debut = GeneratedColumn<DateTime>(
    'debut',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finMeta = const VerificationMeta('fin');
  @override
  late final GeneratedColumn<DateTime> fin = GeneratedColumn<DateTime>(
    'fin',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, accueillantId, debut, fin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'disponibilites_accueil';
  @override
  VerificationContext validateIntegrity(
    Insertable<DisponibiliteAccueil> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('accueillant_id')) {
      context.handle(
        _accueillantIdMeta,
        accueillantId.isAcceptableOrUnknown(
          data['accueillant_id']!,
          _accueillantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accueillantIdMeta);
    }
    if (data.containsKey('debut')) {
      context.handle(
        _debutMeta,
        debut.isAcceptableOrUnknown(data['debut']!, _debutMeta),
      );
    } else if (isInserting) {
      context.missing(_debutMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
        _finMeta,
        fin.isAcceptableOrUnknown(data['fin']!, _finMeta),
      );
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DisponibiliteAccueil map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DisponibiliteAccueil(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accueillantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accueillant_id'],
      )!,
      debut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}debut'],
      )!,
      fin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fin'],
      )!,
    );
  }

  @override
  $DisponibilitesAccueilTable createAlias(String alias) {
    return $DisponibilitesAccueilTable(attachedDatabase, alias);
  }
}

class DisponibiliteAccueil extends DataClass
    implements Insertable<DisponibiliteAccueil> {
  final int id;
  final int accueillantId;
  final DateTime debut;
  final DateTime fin;
  const DisponibiliteAccueil({
    required this.id,
    required this.accueillantId,
    required this.debut,
    required this.fin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['accueillant_id'] = Variable<int>(accueillantId);
    map['debut'] = Variable<DateTime>(debut);
    map['fin'] = Variable<DateTime>(fin);
    return map;
  }

  DisponibilitesAccueilCompanion toCompanion(bool nullToAbsent) {
    return DisponibilitesAccueilCompanion(
      id: Value(id),
      accueillantId: Value(accueillantId),
      debut: Value(debut),
      fin: Value(fin),
    );
  }

  factory DisponibiliteAccueil.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DisponibiliteAccueil(
      id: serializer.fromJson<int>(json['id']),
      accueillantId: serializer.fromJson<int>(json['accueillantId']),
      debut: serializer.fromJson<DateTime>(json['debut']),
      fin: serializer.fromJson<DateTime>(json['fin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accueillantId': serializer.toJson<int>(accueillantId),
      'debut': serializer.toJson<DateTime>(debut),
      'fin': serializer.toJson<DateTime>(fin),
    };
  }

  DisponibiliteAccueil copyWith({
    int? id,
    int? accueillantId,
    DateTime? debut,
    DateTime? fin,
  }) => DisponibiliteAccueil(
    id: id ?? this.id,
    accueillantId: accueillantId ?? this.accueillantId,
    debut: debut ?? this.debut,
    fin: fin ?? this.fin,
  );
  DisponibiliteAccueil copyWithCompanion(DisponibilitesAccueilCompanion data) {
    return DisponibiliteAccueil(
      id: data.id.present ? data.id.value : this.id,
      accueillantId: data.accueillantId.present
          ? data.accueillantId.value
          : this.accueillantId,
      debut: data.debut.present ? data.debut.value : this.debut,
      fin: data.fin.present ? data.fin.value : this.fin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DisponibiliteAccueil(')
          ..write('id: $id, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accueillantId, debut, fin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DisponibiliteAccueil &&
          other.id == this.id &&
          other.accueillantId == this.accueillantId &&
          other.debut == this.debut &&
          other.fin == this.fin);
}

class DisponibilitesAccueilCompanion
    extends UpdateCompanion<DisponibiliteAccueil> {
  final Value<int> id;
  final Value<int> accueillantId;
  final Value<DateTime> debut;
  final Value<DateTime> fin;
  const DisponibilitesAccueilCompanion({
    this.id = const Value.absent(),
    this.accueillantId = const Value.absent(),
    this.debut = const Value.absent(),
    this.fin = const Value.absent(),
  });
  DisponibilitesAccueilCompanion.insert({
    this.id = const Value.absent(),
    required int accueillantId,
    required DateTime debut,
    required DateTime fin,
  }) : accueillantId = Value(accueillantId),
       debut = Value(debut),
       fin = Value(fin);
  static Insertable<DisponibiliteAccueil> custom({
    Expression<int>? id,
    Expression<int>? accueillantId,
    Expression<DateTime>? debut,
    Expression<DateTime>? fin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accueillantId != null) 'accueillant_id': accueillantId,
      if (debut != null) 'debut': debut,
      if (fin != null) 'fin': fin,
    });
  }

  DisponibilitesAccueilCompanion copyWith({
    Value<int>? id,
    Value<int>? accueillantId,
    Value<DateTime>? debut,
    Value<DateTime>? fin,
  }) {
    return DisponibilitesAccueilCompanion(
      id: id ?? this.id,
      accueillantId: accueillantId ?? this.accueillantId,
      debut: debut ?? this.debut,
      fin: fin ?? this.fin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accueillantId.present) {
      map['accueillant_id'] = Variable<int>(accueillantId.value);
    }
    if (debut.present) {
      map['debut'] = Variable<DateTime>(debut.value);
    }
    if (fin.present) {
      map['fin'] = Variable<DateTime>(fin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DisponibilitesAccueilCompanion(')
          ..write('id: $id, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin')
          ..write(')'))
        .toString();
  }
}

class $IndisponibilitesTable extends Indisponibilites
    with TableInfo<$IndisponibilitesTable, Indisponibilite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndisponibilitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accueillantIdMeta = const VerificationMeta(
    'accueillantId',
  );
  @override
  late final GeneratedColumn<int> accueillantId = GeneratedColumn<int>(
    'accueillant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accueillants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _debutMeta = const VerificationMeta('debut');
  @override
  late final GeneratedColumn<DateTime> debut = GeneratedColumn<DateTime>(
    'debut',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finMeta = const VerificationMeta('fin');
  @override
  late final GeneratedColumn<DateTime> fin = GeneratedColumn<DateTime>(
    'fin',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motifMeta = const VerificationMeta('motif');
  @override
  late final GeneratedColumn<String> motif = GeneratedColumn<String>(
    'motif',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, accueillantId, debut, fin, motif];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'indisponibilites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Indisponibilite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('accueillant_id')) {
      context.handle(
        _accueillantIdMeta,
        accueillantId.isAcceptableOrUnknown(
          data['accueillant_id']!,
          _accueillantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accueillantIdMeta);
    }
    if (data.containsKey('debut')) {
      context.handle(
        _debutMeta,
        debut.isAcceptableOrUnknown(data['debut']!, _debutMeta),
      );
    } else if (isInserting) {
      context.missing(_debutMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
        _finMeta,
        fin.isAcceptableOrUnknown(data['fin']!, _finMeta),
      );
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('motif')) {
      context.handle(
        _motifMeta,
        motif.isAcceptableOrUnknown(data['motif']!, _motifMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Indisponibilite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Indisponibilite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accueillantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accueillant_id'],
      )!,
      debut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}debut'],
      )!,
      fin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fin'],
      )!,
      motif: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motif'],
      ),
    );
  }

  @override
  $IndisponibilitesTable createAlias(String alias) {
    return $IndisponibilitesTable(attachedDatabase, alias);
  }
}

class Indisponibilite extends DataClass implements Insertable<Indisponibilite> {
  final int id;
  final int accueillantId;
  final DateTime debut;
  final DateTime fin;
  final String? motif;
  const Indisponibilite({
    required this.id,
    required this.accueillantId,
    required this.debut,
    required this.fin,
    this.motif,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['accueillant_id'] = Variable<int>(accueillantId);
    map['debut'] = Variable<DateTime>(debut);
    map['fin'] = Variable<DateTime>(fin);
    if (!nullToAbsent || motif != null) {
      map['motif'] = Variable<String>(motif);
    }
    return map;
  }

  IndisponibilitesCompanion toCompanion(bool nullToAbsent) {
    return IndisponibilitesCompanion(
      id: Value(id),
      accueillantId: Value(accueillantId),
      debut: Value(debut),
      fin: Value(fin),
      motif: motif == null && nullToAbsent
          ? const Value.absent()
          : Value(motif),
    );
  }

  factory Indisponibilite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Indisponibilite(
      id: serializer.fromJson<int>(json['id']),
      accueillantId: serializer.fromJson<int>(json['accueillantId']),
      debut: serializer.fromJson<DateTime>(json['debut']),
      fin: serializer.fromJson<DateTime>(json['fin']),
      motif: serializer.fromJson<String?>(json['motif']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accueillantId': serializer.toJson<int>(accueillantId),
      'debut': serializer.toJson<DateTime>(debut),
      'fin': serializer.toJson<DateTime>(fin),
      'motif': serializer.toJson<String?>(motif),
    };
  }

  Indisponibilite copyWith({
    int? id,
    int? accueillantId,
    DateTime? debut,
    DateTime? fin,
    Value<String?> motif = const Value.absent(),
  }) => Indisponibilite(
    id: id ?? this.id,
    accueillantId: accueillantId ?? this.accueillantId,
    debut: debut ?? this.debut,
    fin: fin ?? this.fin,
    motif: motif.present ? motif.value : this.motif,
  );
  Indisponibilite copyWithCompanion(IndisponibilitesCompanion data) {
    return Indisponibilite(
      id: data.id.present ? data.id.value : this.id,
      accueillantId: data.accueillantId.present
          ? data.accueillantId.value
          : this.accueillantId,
      debut: data.debut.present ? data.debut.value : this.debut,
      fin: data.fin.present ? data.fin.value : this.fin,
      motif: data.motif.present ? data.motif.value : this.motif,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Indisponibilite(')
          ..write('id: $id, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('motif: $motif')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accueillantId, debut, fin, motif);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Indisponibilite &&
          other.id == this.id &&
          other.accueillantId == this.accueillantId &&
          other.debut == this.debut &&
          other.fin == this.fin &&
          other.motif == this.motif);
}

class IndisponibilitesCompanion extends UpdateCompanion<Indisponibilite> {
  final Value<int> id;
  final Value<int> accueillantId;
  final Value<DateTime> debut;
  final Value<DateTime> fin;
  final Value<String?> motif;
  const IndisponibilitesCompanion({
    this.id = const Value.absent(),
    this.accueillantId = const Value.absent(),
    this.debut = const Value.absent(),
    this.fin = const Value.absent(),
    this.motif = const Value.absent(),
  });
  IndisponibilitesCompanion.insert({
    this.id = const Value.absent(),
    required int accueillantId,
    required DateTime debut,
    required DateTime fin,
    this.motif = const Value.absent(),
  }) : accueillantId = Value(accueillantId),
       debut = Value(debut),
       fin = Value(fin);
  static Insertable<Indisponibilite> custom({
    Expression<int>? id,
    Expression<int>? accueillantId,
    Expression<DateTime>? debut,
    Expression<DateTime>? fin,
    Expression<String>? motif,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accueillantId != null) 'accueillant_id': accueillantId,
      if (debut != null) 'debut': debut,
      if (fin != null) 'fin': fin,
      if (motif != null) 'motif': motif,
    });
  }

  IndisponibilitesCompanion copyWith({
    Value<int>? id,
    Value<int>? accueillantId,
    Value<DateTime>? debut,
    Value<DateTime>? fin,
    Value<String?>? motif,
  }) {
    return IndisponibilitesCompanion(
      id: id ?? this.id,
      accueillantId: accueillantId ?? this.accueillantId,
      debut: debut ?? this.debut,
      fin: fin ?? this.fin,
      motif: motif ?? this.motif,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accueillantId.present) {
      map['accueillant_id'] = Variable<int>(accueillantId.value);
    }
    if (debut.present) {
      map['debut'] = Variable<DateTime>(debut.value);
    }
    if (fin.present) {
      map['fin'] = Variable<DateTime>(fin.value);
    }
    if (motif.present) {
      map['motif'] = Variable<String>(motif.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndisponibilitesCompanion(')
          ..write('id: $id, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('motif: $motif')
          ..write(')'))
        .toString();
  }
}

class $BesoinsRelaisTable extends BesoinsRelais
    with TableInfo<$BesoinsRelaisTable, BesoinRelais> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BesoinsRelaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _enfantIdMeta = const VerificationMeta(
    'enfantId',
  );
  @override
  late final GeneratedColumn<int> enfantId = GeneratedColumn<int>(
    'enfant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES enfants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _debutMeta = const VerificationMeta('debut');
  @override
  late final GeneratedColumn<DateTime> debut = GeneratedColumn<DateTime>(
    'debut',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finMeta = const VerificationMeta('fin');
  @override
  late final GeneratedColumn<DateTime> fin = GeneratedColumn<DateTime>(
    'fin',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motifMeta = const VerificationMeta('motif');
  @override
  late final GeneratedColumn<String> motif = GeneratedColumn<String>(
    'motif',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, enfantId, debut, fin, motif];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'besoins_relais';
  @override
  VerificationContext validateIntegrity(
    Insertable<BesoinRelais> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enfant_id')) {
      context.handle(
        _enfantIdMeta,
        enfantId.isAcceptableOrUnknown(data['enfant_id']!, _enfantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_enfantIdMeta);
    }
    if (data.containsKey('debut')) {
      context.handle(
        _debutMeta,
        debut.isAcceptableOrUnknown(data['debut']!, _debutMeta),
      );
    } else if (isInserting) {
      context.missing(_debutMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
        _finMeta,
        fin.isAcceptableOrUnknown(data['fin']!, _finMeta),
      );
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('motif')) {
      context.handle(
        _motifMeta,
        motif.isAcceptableOrUnknown(data['motif']!, _motifMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BesoinRelais map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BesoinRelais(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enfantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enfant_id'],
      )!,
      debut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}debut'],
      )!,
      fin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fin'],
      )!,
      motif: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motif'],
      ),
    );
  }

  @override
  $BesoinsRelaisTable createAlias(String alias) {
    return $BesoinsRelaisTable(attachedDatabase, alias);
  }
}

class BesoinRelais extends DataClass implements Insertable<BesoinRelais> {
  final int id;
  final int enfantId;
  final DateTime debut;
  final DateTime fin;
  final String? motif;
  const BesoinRelais({
    required this.id,
    required this.enfantId,
    required this.debut,
    required this.fin,
    this.motif,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['enfant_id'] = Variable<int>(enfantId);
    map['debut'] = Variable<DateTime>(debut);
    map['fin'] = Variable<DateTime>(fin);
    if (!nullToAbsent || motif != null) {
      map['motif'] = Variable<String>(motif);
    }
    return map;
  }

  BesoinsRelaisCompanion toCompanion(bool nullToAbsent) {
    return BesoinsRelaisCompanion(
      id: Value(id),
      enfantId: Value(enfantId),
      debut: Value(debut),
      fin: Value(fin),
      motif: motif == null && nullToAbsent
          ? const Value.absent()
          : Value(motif),
    );
  }

  factory BesoinRelais.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BesoinRelais(
      id: serializer.fromJson<int>(json['id']),
      enfantId: serializer.fromJson<int>(json['enfantId']),
      debut: serializer.fromJson<DateTime>(json['debut']),
      fin: serializer.fromJson<DateTime>(json['fin']),
      motif: serializer.fromJson<String?>(json['motif']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enfantId': serializer.toJson<int>(enfantId),
      'debut': serializer.toJson<DateTime>(debut),
      'fin': serializer.toJson<DateTime>(fin),
      'motif': serializer.toJson<String?>(motif),
    };
  }

  BesoinRelais copyWith({
    int? id,
    int? enfantId,
    DateTime? debut,
    DateTime? fin,
    Value<String?> motif = const Value.absent(),
  }) => BesoinRelais(
    id: id ?? this.id,
    enfantId: enfantId ?? this.enfantId,
    debut: debut ?? this.debut,
    fin: fin ?? this.fin,
    motif: motif.present ? motif.value : this.motif,
  );
  BesoinRelais copyWithCompanion(BesoinsRelaisCompanion data) {
    return BesoinRelais(
      id: data.id.present ? data.id.value : this.id,
      enfantId: data.enfantId.present ? data.enfantId.value : this.enfantId,
      debut: data.debut.present ? data.debut.value : this.debut,
      fin: data.fin.present ? data.fin.value : this.fin,
      motif: data.motif.present ? data.motif.value : this.motif,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BesoinRelais(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('motif: $motif')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enfantId, debut, fin, motif);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BesoinRelais &&
          other.id == this.id &&
          other.enfantId == this.enfantId &&
          other.debut == this.debut &&
          other.fin == this.fin &&
          other.motif == this.motif);
}

class BesoinsRelaisCompanion extends UpdateCompanion<BesoinRelais> {
  final Value<int> id;
  final Value<int> enfantId;
  final Value<DateTime> debut;
  final Value<DateTime> fin;
  final Value<String?> motif;
  const BesoinsRelaisCompanion({
    this.id = const Value.absent(),
    this.enfantId = const Value.absent(),
    this.debut = const Value.absent(),
    this.fin = const Value.absent(),
    this.motif = const Value.absent(),
  });
  BesoinsRelaisCompanion.insert({
    this.id = const Value.absent(),
    required int enfantId,
    required DateTime debut,
    required DateTime fin,
    this.motif = const Value.absent(),
  }) : enfantId = Value(enfantId),
       debut = Value(debut),
       fin = Value(fin);
  static Insertable<BesoinRelais> custom({
    Expression<int>? id,
    Expression<int>? enfantId,
    Expression<DateTime>? debut,
    Expression<DateTime>? fin,
    Expression<String>? motif,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enfantId != null) 'enfant_id': enfantId,
      if (debut != null) 'debut': debut,
      if (fin != null) 'fin': fin,
      if (motif != null) 'motif': motif,
    });
  }

  BesoinsRelaisCompanion copyWith({
    Value<int>? id,
    Value<int>? enfantId,
    Value<DateTime>? debut,
    Value<DateTime>? fin,
    Value<String?>? motif,
  }) {
    return BesoinsRelaisCompanion(
      id: id ?? this.id,
      enfantId: enfantId ?? this.enfantId,
      debut: debut ?? this.debut,
      fin: fin ?? this.fin,
      motif: motif ?? this.motif,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enfantId.present) {
      map['enfant_id'] = Variable<int>(enfantId.value);
    }
    if (debut.present) {
      map['debut'] = Variable<DateTime>(debut.value);
    }
    if (fin.present) {
      map['fin'] = Variable<DateTime>(fin.value);
    }
    if (motif.present) {
      map['motif'] = Variable<String>(motif.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BesoinsRelaisCompanion(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('motif: $motif')
          ..write(')'))
        .toString();
  }
}

class $AffectationsTable extends Affectations
    with TableInfo<$AffectationsTable, Affectation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AffectationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _enfantIdMeta = const VerificationMeta(
    'enfantId',
  );
  @override
  late final GeneratedColumn<int> enfantId = GeneratedColumn<int>(
    'enfant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES enfants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _accueillantIdMeta = const VerificationMeta(
    'accueillantId',
  );
  @override
  late final GeneratedColumn<int> accueillantId = GeneratedColumn<int>(
    'accueillant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accueillants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _debutMeta = const VerificationMeta('debut');
  @override
  late final GeneratedColumn<DateTime> debut = GeneratedColumn<DateTime>(
    'debut',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finMeta = const VerificationMeta('fin');
  @override
  late final GeneratedColumn<DateTime> fin = GeneratedColumn<DateTime>(
    'fin',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _besoinIdMeta = const VerificationMeta(
    'besoinId',
  );
  @override
  late final GeneratedColumn<int> besoinId = GeneratedColumn<int>(
    'besoin_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES besoins_relais (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
    'statut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(statutConfirme),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    enfantId,
    accueillantId,
    debut,
    fin,
    besoinId,
    statut,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'affectations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Affectation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enfant_id')) {
      context.handle(
        _enfantIdMeta,
        enfantId.isAcceptableOrUnknown(data['enfant_id']!, _enfantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_enfantIdMeta);
    }
    if (data.containsKey('accueillant_id')) {
      context.handle(
        _accueillantIdMeta,
        accueillantId.isAcceptableOrUnknown(
          data['accueillant_id']!,
          _accueillantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accueillantIdMeta);
    }
    if (data.containsKey('debut')) {
      context.handle(
        _debutMeta,
        debut.isAcceptableOrUnknown(data['debut']!, _debutMeta),
      );
    } else if (isInserting) {
      context.missing(_debutMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
        _finMeta,
        fin.isAcceptableOrUnknown(data['fin']!, _finMeta),
      );
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('besoin_id')) {
      context.handle(
        _besoinIdMeta,
        besoinId.isAcceptableOrUnknown(data['besoin_id']!, _besoinIdMeta),
      );
    }
    if (data.containsKey('statut')) {
      context.handle(
        _statutMeta,
        statut.isAcceptableOrUnknown(data['statut']!, _statutMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Affectation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Affectation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enfantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enfant_id'],
      )!,
      accueillantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accueillant_id'],
      )!,
      debut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}debut'],
      )!,
      fin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fin'],
      )!,
      besoinId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}besoin_id'],
      ),
      statut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut'],
      )!,
    );
  }

  @override
  $AffectationsTable createAlias(String alias) {
    return $AffectationsTable(attachedDatabase, alias);
  }
}

class Affectation extends DataClass implements Insertable<Affectation> {
  final int id;
  final int enfantId;
  final int accueillantId;
  final DateTime debut;
  final DateTime fin;
  final int? besoinId;
  final String statut;
  const Affectation({
    required this.id,
    required this.enfantId,
    required this.accueillantId,
    required this.debut,
    required this.fin,
    this.besoinId,
    required this.statut,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['enfant_id'] = Variable<int>(enfantId);
    map['accueillant_id'] = Variable<int>(accueillantId);
    map['debut'] = Variable<DateTime>(debut);
    map['fin'] = Variable<DateTime>(fin);
    if (!nullToAbsent || besoinId != null) {
      map['besoin_id'] = Variable<int>(besoinId);
    }
    map['statut'] = Variable<String>(statut);
    return map;
  }

  AffectationsCompanion toCompanion(bool nullToAbsent) {
    return AffectationsCompanion(
      id: Value(id),
      enfantId: Value(enfantId),
      accueillantId: Value(accueillantId),
      debut: Value(debut),
      fin: Value(fin),
      besoinId: besoinId == null && nullToAbsent
          ? const Value.absent()
          : Value(besoinId),
      statut: Value(statut),
    );
  }

  factory Affectation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Affectation(
      id: serializer.fromJson<int>(json['id']),
      enfantId: serializer.fromJson<int>(json['enfantId']),
      accueillantId: serializer.fromJson<int>(json['accueillantId']),
      debut: serializer.fromJson<DateTime>(json['debut']),
      fin: serializer.fromJson<DateTime>(json['fin']),
      besoinId: serializer.fromJson<int?>(json['besoinId']),
      statut: serializer.fromJson<String>(json['statut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enfantId': serializer.toJson<int>(enfantId),
      'accueillantId': serializer.toJson<int>(accueillantId),
      'debut': serializer.toJson<DateTime>(debut),
      'fin': serializer.toJson<DateTime>(fin),
      'besoinId': serializer.toJson<int?>(besoinId),
      'statut': serializer.toJson<String>(statut),
    };
  }

  Affectation copyWith({
    int? id,
    int? enfantId,
    int? accueillantId,
    DateTime? debut,
    DateTime? fin,
    Value<int?> besoinId = const Value.absent(),
    String? statut,
  }) => Affectation(
    id: id ?? this.id,
    enfantId: enfantId ?? this.enfantId,
    accueillantId: accueillantId ?? this.accueillantId,
    debut: debut ?? this.debut,
    fin: fin ?? this.fin,
    besoinId: besoinId.present ? besoinId.value : this.besoinId,
    statut: statut ?? this.statut,
  );
  Affectation copyWithCompanion(AffectationsCompanion data) {
    return Affectation(
      id: data.id.present ? data.id.value : this.id,
      enfantId: data.enfantId.present ? data.enfantId.value : this.enfantId,
      accueillantId: data.accueillantId.present
          ? data.accueillantId.value
          : this.accueillantId,
      debut: data.debut.present ? data.debut.value : this.debut,
      fin: data.fin.present ? data.fin.value : this.fin,
      besoinId: data.besoinId.present ? data.besoinId.value : this.besoinId,
      statut: data.statut.present ? data.statut.value : this.statut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Affectation(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('besoinId: $besoinId, ')
          ..write('statut: $statut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, enfantId, accueillantId, debut, fin, besoinId, statut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Affectation &&
          other.id == this.id &&
          other.enfantId == this.enfantId &&
          other.accueillantId == this.accueillantId &&
          other.debut == this.debut &&
          other.fin == this.fin &&
          other.besoinId == this.besoinId &&
          other.statut == this.statut);
}

class AffectationsCompanion extends UpdateCompanion<Affectation> {
  final Value<int> id;
  final Value<int> enfantId;
  final Value<int> accueillantId;
  final Value<DateTime> debut;
  final Value<DateTime> fin;
  final Value<int?> besoinId;
  final Value<String> statut;
  const AffectationsCompanion({
    this.id = const Value.absent(),
    this.enfantId = const Value.absent(),
    this.accueillantId = const Value.absent(),
    this.debut = const Value.absent(),
    this.fin = const Value.absent(),
    this.besoinId = const Value.absent(),
    this.statut = const Value.absent(),
  });
  AffectationsCompanion.insert({
    this.id = const Value.absent(),
    required int enfantId,
    required int accueillantId,
    required DateTime debut,
    required DateTime fin,
    this.besoinId = const Value.absent(),
    this.statut = const Value.absent(),
  }) : enfantId = Value(enfantId),
       accueillantId = Value(accueillantId),
       debut = Value(debut),
       fin = Value(fin);
  static Insertable<Affectation> custom({
    Expression<int>? id,
    Expression<int>? enfantId,
    Expression<int>? accueillantId,
    Expression<DateTime>? debut,
    Expression<DateTime>? fin,
    Expression<int>? besoinId,
    Expression<String>? statut,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enfantId != null) 'enfant_id': enfantId,
      if (accueillantId != null) 'accueillant_id': accueillantId,
      if (debut != null) 'debut': debut,
      if (fin != null) 'fin': fin,
      if (besoinId != null) 'besoin_id': besoinId,
      if (statut != null) 'statut': statut,
    });
  }

  AffectationsCompanion copyWith({
    Value<int>? id,
    Value<int>? enfantId,
    Value<int>? accueillantId,
    Value<DateTime>? debut,
    Value<DateTime>? fin,
    Value<int?>? besoinId,
    Value<String>? statut,
  }) {
    return AffectationsCompanion(
      id: id ?? this.id,
      enfantId: enfantId ?? this.enfantId,
      accueillantId: accueillantId ?? this.accueillantId,
      debut: debut ?? this.debut,
      fin: fin ?? this.fin,
      besoinId: besoinId ?? this.besoinId,
      statut: statut ?? this.statut,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enfantId.present) {
      map['enfant_id'] = Variable<int>(enfantId.value);
    }
    if (accueillantId.present) {
      map['accueillant_id'] = Variable<int>(accueillantId.value);
    }
    if (debut.present) {
      map['debut'] = Variable<DateTime>(debut.value);
    }
    if (fin.present) {
      map['fin'] = Variable<DateTime>(fin.value);
    }
    if (besoinId.present) {
      map['besoin_id'] = Variable<int>(besoinId.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AffectationsCompanion(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('besoinId: $besoinId, ')
          ..write('statut: $statut')
          ..write(')'))
        .toString();
  }
}

class $IncompatibilitesTable extends Incompatibilites
    with TableInfo<$IncompatibilitesTable, Incompatibilite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncompatibilitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _enfantAIdMeta = const VerificationMeta(
    'enfantAId',
  );
  @override
  late final GeneratedColumn<int> enfantAId = GeneratedColumn<int>(
    'enfant_a_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES enfants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _enfantBIdMeta = const VerificationMeta(
    'enfantBId',
  );
  @override
  late final GeneratedColumn<int> enfantBId = GeneratedColumn<int>(
    'enfant_b_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES enfants (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, enfantAId, enfantBId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incompatibilites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Incompatibilite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enfant_a_id')) {
      context.handle(
        _enfantAIdMeta,
        enfantAId.isAcceptableOrUnknown(data['enfant_a_id']!, _enfantAIdMeta),
      );
    } else if (isInserting) {
      context.missing(_enfantAIdMeta);
    }
    if (data.containsKey('enfant_b_id')) {
      context.handle(
        _enfantBIdMeta,
        enfantBId.isAcceptableOrUnknown(data['enfant_b_id']!, _enfantBIdMeta),
      );
    } else if (isInserting) {
      context.missing(_enfantBIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Incompatibilite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Incompatibilite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enfantAId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enfant_a_id'],
      )!,
      enfantBId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enfant_b_id'],
      )!,
    );
  }

  @override
  $IncompatibilitesTable createAlias(String alias) {
    return $IncompatibilitesTable(attachedDatabase, alias);
  }
}

class Incompatibilite extends DataClass implements Insertable<Incompatibilite> {
  final int id;
  final int enfantAId;
  final int enfantBId;
  const Incompatibilite({
    required this.id,
    required this.enfantAId,
    required this.enfantBId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['enfant_a_id'] = Variable<int>(enfantAId);
    map['enfant_b_id'] = Variable<int>(enfantBId);
    return map;
  }

  IncompatibilitesCompanion toCompanion(bool nullToAbsent) {
    return IncompatibilitesCompanion(
      id: Value(id),
      enfantAId: Value(enfantAId),
      enfantBId: Value(enfantBId),
    );
  }

  factory Incompatibilite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Incompatibilite(
      id: serializer.fromJson<int>(json['id']),
      enfantAId: serializer.fromJson<int>(json['enfantAId']),
      enfantBId: serializer.fromJson<int>(json['enfantBId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enfantAId': serializer.toJson<int>(enfantAId),
      'enfantBId': serializer.toJson<int>(enfantBId),
    };
  }

  Incompatibilite copyWith({int? id, int? enfantAId, int? enfantBId}) =>
      Incompatibilite(
        id: id ?? this.id,
        enfantAId: enfantAId ?? this.enfantAId,
        enfantBId: enfantBId ?? this.enfantBId,
      );
  Incompatibilite copyWithCompanion(IncompatibilitesCompanion data) {
    return Incompatibilite(
      id: data.id.present ? data.id.value : this.id,
      enfantAId: data.enfantAId.present ? data.enfantAId.value : this.enfantAId,
      enfantBId: data.enfantBId.present ? data.enfantBId.value : this.enfantBId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Incompatibilite(')
          ..write('id: $id, ')
          ..write('enfantAId: $enfantAId, ')
          ..write('enfantBId: $enfantBId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enfantAId, enfantBId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Incompatibilite &&
          other.id == this.id &&
          other.enfantAId == this.enfantAId &&
          other.enfantBId == this.enfantBId);
}

class IncompatibilitesCompanion extends UpdateCompanion<Incompatibilite> {
  final Value<int> id;
  final Value<int> enfantAId;
  final Value<int> enfantBId;
  const IncompatibilitesCompanion({
    this.id = const Value.absent(),
    this.enfantAId = const Value.absent(),
    this.enfantBId = const Value.absent(),
  });
  IncompatibilitesCompanion.insert({
    this.id = const Value.absent(),
    required int enfantAId,
    required int enfantBId,
  }) : enfantAId = Value(enfantAId),
       enfantBId = Value(enfantBId);
  static Insertable<Incompatibilite> custom({
    Expression<int>? id,
    Expression<int>? enfantAId,
    Expression<int>? enfantBId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enfantAId != null) 'enfant_a_id': enfantAId,
      if (enfantBId != null) 'enfant_b_id': enfantBId,
    });
  }

  IncompatibilitesCompanion copyWith({
    Value<int>? id,
    Value<int>? enfantAId,
    Value<int>? enfantBId,
  }) {
    return IncompatibilitesCompanion(
      id: id ?? this.id,
      enfantAId: enfantAId ?? this.enfantAId,
      enfantBId: enfantBId ?? this.enfantBId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enfantAId.present) {
      map['enfant_a_id'] = Variable<int>(enfantAId.value);
    }
    if (enfantBId.present) {
      map['enfant_b_id'] = Variable<int>(enfantBId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncompatibilitesCompanion(')
          ..write('id: $id, ')
          ..write('enfantAId: $enfantAId, ')
          ..write('enfantBId: $enfantBId')
          ..write(')'))
        .toString();
  }
}

class $PreferencesAccueilTable extends PreferencesAccueil
    with TableInfo<$PreferencesAccueilTable, PreferenceAccueil> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesAccueilTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _enfantIdMeta = const VerificationMeta(
    'enfantId',
  );
  @override
  late final GeneratedColumn<int> enfantId = GeneratedColumn<int>(
    'enfant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES enfants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _accueillantIdMeta = const VerificationMeta(
    'accueillantId',
  );
  @override
  late final GeneratedColumn<int> accueillantId = GeneratedColumn<int>(
    'accueillant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accueillants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, enfantId, accueillantId, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences_accueil';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceAccueil> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enfant_id')) {
      context.handle(
        _enfantIdMeta,
        enfantId.isAcceptableOrUnknown(data['enfant_id']!, _enfantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_enfantIdMeta);
    }
    if (data.containsKey('accueillant_id')) {
      context.handle(
        _accueillantIdMeta,
        accueillantId.isAcceptableOrUnknown(
          data['accueillant_id']!,
          _accueillantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accueillantIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferenceAccueil map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceAccueil(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enfantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enfant_id'],
      )!,
      accueillantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accueillant_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $PreferencesAccueilTable createAlias(String alias) {
    return $PreferencesAccueilTable(attachedDatabase, alias);
  }
}

class PreferenceAccueil extends DataClass
    implements Insertable<PreferenceAccueil> {
  final int id;
  final int enfantId;
  final int accueillantId;
  final String type;
  const PreferenceAccueil({
    required this.id,
    required this.enfantId,
    required this.accueillantId,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['enfant_id'] = Variable<int>(enfantId);
    map['accueillant_id'] = Variable<int>(accueillantId);
    map['type'] = Variable<String>(type);
    return map;
  }

  PreferencesAccueilCompanion toCompanion(bool nullToAbsent) {
    return PreferencesAccueilCompanion(
      id: Value(id),
      enfantId: Value(enfantId),
      accueillantId: Value(accueillantId),
      type: Value(type),
    );
  }

  factory PreferenceAccueil.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceAccueil(
      id: serializer.fromJson<int>(json['id']),
      enfantId: serializer.fromJson<int>(json['enfantId']),
      accueillantId: serializer.fromJson<int>(json['accueillantId']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enfantId': serializer.toJson<int>(enfantId),
      'accueillantId': serializer.toJson<int>(accueillantId),
      'type': serializer.toJson<String>(type),
    };
  }

  PreferenceAccueil copyWith({
    int? id,
    int? enfantId,
    int? accueillantId,
    String? type,
  }) => PreferenceAccueil(
    id: id ?? this.id,
    enfantId: enfantId ?? this.enfantId,
    accueillantId: accueillantId ?? this.accueillantId,
    type: type ?? this.type,
  );
  PreferenceAccueil copyWithCompanion(PreferencesAccueilCompanion data) {
    return PreferenceAccueil(
      id: data.id.present ? data.id.value : this.id,
      enfantId: data.enfantId.present ? data.enfantId.value : this.enfantId,
      accueillantId: data.accueillantId.present
          ? data.accueillantId.value
          : this.accueillantId,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceAccueil(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enfantId, accueillantId, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceAccueil &&
          other.id == this.id &&
          other.enfantId == this.enfantId &&
          other.accueillantId == this.accueillantId &&
          other.type == this.type);
}

class PreferencesAccueilCompanion extends UpdateCompanion<PreferenceAccueil> {
  final Value<int> id;
  final Value<int> enfantId;
  final Value<int> accueillantId;
  final Value<String> type;
  const PreferencesAccueilCompanion({
    this.id = const Value.absent(),
    this.enfantId = const Value.absent(),
    this.accueillantId = const Value.absent(),
    this.type = const Value.absent(),
  });
  PreferencesAccueilCompanion.insert({
    this.id = const Value.absent(),
    required int enfantId,
    required int accueillantId,
    required String type,
  }) : enfantId = Value(enfantId),
       accueillantId = Value(accueillantId),
       type = Value(type);
  static Insertable<PreferenceAccueil> custom({
    Expression<int>? id,
    Expression<int>? enfantId,
    Expression<int>? accueillantId,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enfantId != null) 'enfant_id': enfantId,
      if (accueillantId != null) 'accueillant_id': accueillantId,
      if (type != null) 'type': type,
    });
  }

  PreferencesAccueilCompanion copyWith({
    Value<int>? id,
    Value<int>? enfantId,
    Value<int>? accueillantId,
    Value<String>? type,
  }) {
    return PreferencesAccueilCompanion(
      id: id ?? this.id,
      enfantId: enfantId ?? this.enfantId,
      accueillantId: accueillantId ?? this.accueillantId,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enfantId.present) {
      map['enfant_id'] = Variable<int>(enfantId.value);
    }
    if (accueillantId.present) {
      map['accueillant_id'] = Variable<int>(accueillantId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesAccueilCompanion(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('accueillantId: $accueillantId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $SolutionsAlternativesTable extends SolutionsAlternatives
    with TableInfo<$SolutionsAlternativesTable, SolutionAlternative> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SolutionsAlternativesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _enfantIdMeta = const VerificationMeta(
    'enfantId',
  );
  @override
  late final GeneratedColumn<int> enfantId = GeneratedColumn<int>(
    'enfant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES enfants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _debutMeta = const VerificationMeta('debut');
  @override
  late final GeneratedColumn<DateTime> debut = GeneratedColumn<DateTime>(
    'debut',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finMeta = const VerificationMeta('fin');
  @override
  late final GeneratedColumn<DateTime> fin = GeneratedColumn<DateTime>(
    'fin',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    enfantId,
    debut,
    fin,
    type,
    details,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'solutions_alternatives';
  @override
  VerificationContext validateIntegrity(
    Insertable<SolutionAlternative> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enfant_id')) {
      context.handle(
        _enfantIdMeta,
        enfantId.isAcceptableOrUnknown(data['enfant_id']!, _enfantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_enfantIdMeta);
    }
    if (data.containsKey('debut')) {
      context.handle(
        _debutMeta,
        debut.isAcceptableOrUnknown(data['debut']!, _debutMeta),
      );
    } else if (isInserting) {
      context.missing(_debutMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
        _finMeta,
        fin.isAcceptableOrUnknown(data['fin']!, _finMeta),
      );
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SolutionAlternative map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SolutionAlternative(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enfantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enfant_id'],
      )!,
      debut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}debut'],
      )!,
      fin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fin'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
    );
  }

  @override
  $SolutionsAlternativesTable createAlias(String alias) {
    return $SolutionsAlternativesTable(attachedDatabase, alias);
  }
}

class SolutionAlternative extends DataClass
    implements Insertable<SolutionAlternative> {
  final int id;
  final int enfantId;
  final DateTime debut;
  final DateTime fin;
  final String type;
  final String? details;
  const SolutionAlternative({
    required this.id,
    required this.enfantId,
    required this.debut,
    required this.fin,
    required this.type,
    this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['enfant_id'] = Variable<int>(enfantId);
    map['debut'] = Variable<DateTime>(debut);
    map['fin'] = Variable<DateTime>(fin);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    return map;
  }

  SolutionsAlternativesCompanion toCompanion(bool nullToAbsent) {
    return SolutionsAlternativesCompanion(
      id: Value(id),
      enfantId: Value(enfantId),
      debut: Value(debut),
      fin: Value(fin),
      type: Value(type),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
    );
  }

  factory SolutionAlternative.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SolutionAlternative(
      id: serializer.fromJson<int>(json['id']),
      enfantId: serializer.fromJson<int>(json['enfantId']),
      debut: serializer.fromJson<DateTime>(json['debut']),
      fin: serializer.fromJson<DateTime>(json['fin']),
      type: serializer.fromJson<String>(json['type']),
      details: serializer.fromJson<String?>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enfantId': serializer.toJson<int>(enfantId),
      'debut': serializer.toJson<DateTime>(debut),
      'fin': serializer.toJson<DateTime>(fin),
      'type': serializer.toJson<String>(type),
      'details': serializer.toJson<String?>(details),
    };
  }

  SolutionAlternative copyWith({
    int? id,
    int? enfantId,
    DateTime? debut,
    DateTime? fin,
    String? type,
    Value<String?> details = const Value.absent(),
  }) => SolutionAlternative(
    id: id ?? this.id,
    enfantId: enfantId ?? this.enfantId,
    debut: debut ?? this.debut,
    fin: fin ?? this.fin,
    type: type ?? this.type,
    details: details.present ? details.value : this.details,
  );
  SolutionAlternative copyWithCompanion(SolutionsAlternativesCompanion data) {
    return SolutionAlternative(
      id: data.id.present ? data.id.value : this.id,
      enfantId: data.enfantId.present ? data.enfantId.value : this.enfantId,
      debut: data.debut.present ? data.debut.value : this.debut,
      fin: data.fin.present ? data.fin.value : this.fin,
      type: data.type.present ? data.type.value : this.type,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SolutionAlternative(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('type: $type, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enfantId, debut, fin, type, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SolutionAlternative &&
          other.id == this.id &&
          other.enfantId == this.enfantId &&
          other.debut == this.debut &&
          other.fin == this.fin &&
          other.type == this.type &&
          other.details == this.details);
}

class SolutionsAlternativesCompanion
    extends UpdateCompanion<SolutionAlternative> {
  final Value<int> id;
  final Value<int> enfantId;
  final Value<DateTime> debut;
  final Value<DateTime> fin;
  final Value<String> type;
  final Value<String?> details;
  const SolutionsAlternativesCompanion({
    this.id = const Value.absent(),
    this.enfantId = const Value.absent(),
    this.debut = const Value.absent(),
    this.fin = const Value.absent(),
    this.type = const Value.absent(),
    this.details = const Value.absent(),
  });
  SolutionsAlternativesCompanion.insert({
    this.id = const Value.absent(),
    required int enfantId,
    required DateTime debut,
    required DateTime fin,
    required String type,
    this.details = const Value.absent(),
  }) : enfantId = Value(enfantId),
       debut = Value(debut),
       fin = Value(fin),
       type = Value(type);
  static Insertable<SolutionAlternative> custom({
    Expression<int>? id,
    Expression<int>? enfantId,
    Expression<DateTime>? debut,
    Expression<DateTime>? fin,
    Expression<String>? type,
    Expression<String>? details,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enfantId != null) 'enfant_id': enfantId,
      if (debut != null) 'debut': debut,
      if (fin != null) 'fin': fin,
      if (type != null) 'type': type,
      if (details != null) 'details': details,
    });
  }

  SolutionsAlternativesCompanion copyWith({
    Value<int>? id,
    Value<int>? enfantId,
    Value<DateTime>? debut,
    Value<DateTime>? fin,
    Value<String>? type,
    Value<String?>? details,
  }) {
    return SolutionsAlternativesCompanion(
      id: id ?? this.id,
      enfantId: enfantId ?? this.enfantId,
      debut: debut ?? this.debut,
      fin: fin ?? this.fin,
      type: type ?? this.type,
      details: details ?? this.details,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enfantId.present) {
      map['enfant_id'] = Variable<int>(enfantId.value);
    }
    if (debut.present) {
      map['debut'] = Variable<DateTime>(debut.value);
    }
    if (fin.present) {
      map['fin'] = Variable<DateTime>(fin.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SolutionsAlternativesCompanion(')
          ..write('id: $id, ')
          ..write('enfantId: $enfantId, ')
          ..write('debut: $debut, ')
          ..write('fin: $fin, ')
          ..write('type: $type, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }
}

class $ReglagesTable extends Reglages with TableInfo<$ReglagesTable, Reglage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReglagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cleMeta = const VerificationMeta('cle');
  @override
  late final GeneratedColumn<String> cle = GeneratedColumn<String>(
    'cle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  @override
  late final GeneratedColumn<String> valeur = GeneratedColumn<String>(
    'valeur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [cle, valeur];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reglages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reglage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cle')) {
      context.handle(
        _cleMeta,
        cle.isAcceptableOrUnknown(data['cle']!, _cleMeta),
      );
    } else if (isInserting) {
      context.missing(_cleMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(
        _valeurMeta,
        valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cle};
  @override
  Reglage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reglage(
      cle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cle'],
      )!,
      valeur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valeur'],
      )!,
    );
  }

  @override
  $ReglagesTable createAlias(String alias) {
    return $ReglagesTable(attachedDatabase, alias);
  }
}

class Reglage extends DataClass implements Insertable<Reglage> {
  final String cle;
  final String valeur;
  const Reglage({required this.cle, required this.valeur});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cle'] = Variable<String>(cle);
    map['valeur'] = Variable<String>(valeur);
    return map;
  }

  ReglagesCompanion toCompanion(bool nullToAbsent) {
    return ReglagesCompanion(cle: Value(cle), valeur: Value(valeur));
  }

  factory Reglage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reglage(
      cle: serializer.fromJson<String>(json['cle']),
      valeur: serializer.fromJson<String>(json['valeur']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cle': serializer.toJson<String>(cle),
      'valeur': serializer.toJson<String>(valeur),
    };
  }

  Reglage copyWith({String? cle, String? valeur}) =>
      Reglage(cle: cle ?? this.cle, valeur: valeur ?? this.valeur);
  Reglage copyWithCompanion(ReglagesCompanion data) {
    return Reglage(
      cle: data.cle.present ? data.cle.value : this.cle,
      valeur: data.valeur.present ? data.valeur.value : this.valeur,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reglage(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cle, valeur);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reglage &&
          other.cle == this.cle &&
          other.valeur == this.valeur);
}

class ReglagesCompanion extends UpdateCompanion<Reglage> {
  final Value<String> cle;
  final Value<String> valeur;
  final Value<int> rowid;
  const ReglagesCompanion({
    this.cle = const Value.absent(),
    this.valeur = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReglagesCompanion.insert({
    required String cle,
    this.valeur = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cle = Value(cle);
  static Insertable<Reglage> custom({
    Expression<String>? cle,
    Expression<String>? valeur,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cle != null) 'cle': cle,
      if (valeur != null) 'valeur': valeur,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReglagesCompanion copyWith({
    Value<String>? cle,
    Value<String>? valeur,
    Value<int>? rowid,
  }) {
    return ReglagesCompanion(
      cle: cle ?? this.cle,
      valeur: valeur ?? this.valeur,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cle.present) {
      map['cle'] = Variable<String>(cle.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<String>(valeur.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReglagesCompanion(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccueillantsTable accueillants = $AccueillantsTable(this);
  late final $FratriesTable fratries = $FratriesTable(this);
  late final $EnfantsTable enfants = $EnfantsTable(this);
  late final $DisponibilitesAccueilTable disponibilitesAccueil =
      $DisponibilitesAccueilTable(this);
  late final $IndisponibilitesTable indisponibilites = $IndisponibilitesTable(
    this,
  );
  late final $BesoinsRelaisTable besoinsRelais = $BesoinsRelaisTable(this);
  late final $AffectationsTable affectations = $AffectationsTable(this);
  late final $IncompatibilitesTable incompatibilites = $IncompatibilitesTable(
    this,
  );
  late final $PreferencesAccueilTable preferencesAccueil =
      $PreferencesAccueilTable(this);
  late final $SolutionsAlternativesTable solutionsAlternatives =
      $SolutionsAlternativesTable(this);
  late final $ReglagesTable reglages = $ReglagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accueillants,
    fratries,
    enfants,
    disponibilitesAccueil,
    indisponibilites,
    besoinsRelais,
    affectations,
    incompatibilites,
    preferencesAccueil,
    solutionsAlternatives,
    reglages,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accueillants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('enfants', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'fratries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('enfants', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accueillants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('disponibilites_accueil', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accueillants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('indisponibilites', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'enfants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('besoins_relais', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'enfants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('affectations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accueillants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('affectations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'besoins_relais',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('affectations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'enfants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('incompatibilites', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'enfants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('incompatibilites', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'enfants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('preferences_accueil', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accueillants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('preferences_accueil', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'enfants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('solutions_alternatives', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AccueillantsTableCreateCompanionBuilder =
    AccueillantsCompanion Function({
      Value<int> id,
      required String nom,
      Value<String> prenom,
      Value<int> nbPlaces,
      Value<String> restrictionSexe,
      Value<int?> ageMin,
      Value<int?> ageMax,
      Value<DateTime?> agrementEcheance,
      Value<String?> notes,
    });
typedef $$AccueillantsTableUpdateCompanionBuilder =
    AccueillantsCompanion Function({
      Value<int> id,
      Value<String> nom,
      Value<String> prenom,
      Value<int> nbPlaces,
      Value<String> restrictionSexe,
      Value<int?> ageMin,
      Value<int?> ageMax,
      Value<DateTime?> agrementEcheance,
      Value<String?> notes,
    });

final class $$AccueillantsTableReferences
    extends BaseReferences<_$AppDatabase, $AccueillantsTable, Accueillant> {
  $$AccueillantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EnfantsTable, List<Enfant>> _enfantsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.enfants,
    aliasName: 'accueillants__id__enfants__af_habituel_id',
  );

  $$EnfantsTableProcessedTableManager get enfantsRefs {
    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.afHabituelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_enfantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DisponibilitesAccueilTable,
    List<DisponibiliteAccueil>
  >
  _disponibilitesAccueilRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.disponibilitesAccueil,
        aliasName: 'accueillants__id__disponibilites_accueil__accueillant_id',
      );

  $$DisponibilitesAccueilTableProcessedTableManager
  get disponibilitesAccueilRefs {
    final manager = $$DisponibilitesAccueilTableTableManager(
      $_db,
      $_db.disponibilitesAccueil,
    ).filter((f) => f.accueillantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _disponibilitesAccueilRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IndisponibilitesTable, List<Indisponibilite>>
  _indisponibilitesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.indisponibilites,
    aliasName: 'accueillants__id__indisponibilites__accueillant_id',
  );

  $$IndisponibilitesTableProcessedTableManager get indisponibilitesRefs {
    final manager = $$IndisponibilitesTableTableManager(
      $_db,
      $_db.indisponibilites,
    ).filter((f) => f.accueillantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _indisponibilitesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AffectationsTable, List<Affectation>>
  _affectationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.affectations,
    aliasName: 'accueillants__id__affectations__accueillant_id',
  );

  $$AffectationsTableProcessedTableManager get affectationsRefs {
    final manager = $$AffectationsTableTableManager(
      $_db,
      $_db.affectations,
    ).filter((f) => f.accueillantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_affectationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PreferencesAccueilTable, List<PreferenceAccueil>>
  _preferencesAccueilRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.preferencesAccueil,
        aliasName: 'accueillants__id__preferences_accueil__accueillant_id',
      );

  $$PreferencesAccueilTableProcessedTableManager get preferencesAccueilRefs {
    final manager = $$PreferencesAccueilTableTableManager(
      $_db,
      $_db.preferencesAccueil,
    ).filter((f) => f.accueillantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _preferencesAccueilRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccueillantsTableFilterComposer
    extends Composer<_$AppDatabase, $AccueillantsTable> {
  $$AccueillantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nbPlaces => $composableBuilder(
    column: $table.nbPlaces,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get restrictionSexe => $composableBuilder(
    column: $table.restrictionSexe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ageMin => $composableBuilder(
    column: $table.ageMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ageMax => $composableBuilder(
    column: $table.ageMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get agrementEcheance => $composableBuilder(
    column: $table.agrementEcheance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> enfantsRefs(
    Expression<bool> Function($$EnfantsTableFilterComposer f) f,
  ) {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.afHabituelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> disponibilitesAccueilRefs(
    Expression<bool> Function($$DisponibilitesAccueilTableFilterComposer f) f,
  ) {
    final $$DisponibilitesAccueilTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.disponibilitesAccueil,
          getReferencedColumn: (t) => t.accueillantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DisponibilitesAccueilTableFilterComposer(
                $db: $db,
                $table: $db.disponibilitesAccueil,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> indisponibilitesRefs(
    Expression<bool> Function($$IndisponibilitesTableFilterComposer f) f,
  ) {
    final $$IndisponibilitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.indisponibilites,
      getReferencedColumn: (t) => t.accueillantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndisponibilitesTableFilterComposer(
            $db: $db,
            $table: $db.indisponibilites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> affectationsRefs(
    Expression<bool> Function($$AffectationsTableFilterComposer f) f,
  ) {
    final $$AffectationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.affectations,
      getReferencedColumn: (t) => t.accueillantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AffectationsTableFilterComposer(
            $db: $db,
            $table: $db.affectations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> preferencesAccueilRefs(
    Expression<bool> Function($$PreferencesAccueilTableFilterComposer f) f,
  ) {
    final $$PreferencesAccueilTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preferencesAccueil,
      getReferencedColumn: (t) => t.accueillantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreferencesAccueilTableFilterComposer(
            $db: $db,
            $table: $db.preferencesAccueil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccueillantsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccueillantsTable> {
  $$AccueillantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nbPlaces => $composableBuilder(
    column: $table.nbPlaces,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get restrictionSexe => $composableBuilder(
    column: $table.restrictionSexe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ageMin => $composableBuilder(
    column: $table.ageMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ageMax => $composableBuilder(
    column: $table.ageMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get agrementEcheance => $composableBuilder(
    column: $table.agrementEcheance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccueillantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccueillantsTable> {
  $$AccueillantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<int> get nbPlaces =>
      $composableBuilder(column: $table.nbPlaces, builder: (column) => column);

  GeneratedColumn<String> get restrictionSexe => $composableBuilder(
    column: $table.restrictionSexe,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ageMin =>
      $composableBuilder(column: $table.ageMin, builder: (column) => column);

  GeneratedColumn<int> get ageMax =>
      $composableBuilder(column: $table.ageMax, builder: (column) => column);

  GeneratedColumn<DateTime> get agrementEcheance => $composableBuilder(
    column: $table.agrementEcheance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> enfantsRefs<T extends Object>(
    Expression<T> Function($$EnfantsTableAnnotationComposer a) f,
  ) {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.afHabituelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> disponibilitesAccueilRefs<T extends Object>(
    Expression<T> Function($$DisponibilitesAccueilTableAnnotationComposer a) f,
  ) {
    final $$DisponibilitesAccueilTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.disponibilitesAccueil,
          getReferencedColumn: (t) => t.accueillantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DisponibilitesAccueilTableAnnotationComposer(
                $db: $db,
                $table: $db.disponibilitesAccueil,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> indisponibilitesRefs<T extends Object>(
    Expression<T> Function($$IndisponibilitesTableAnnotationComposer a) f,
  ) {
    final $$IndisponibilitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.indisponibilites,
      getReferencedColumn: (t) => t.accueillantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndisponibilitesTableAnnotationComposer(
            $db: $db,
            $table: $db.indisponibilites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> affectationsRefs<T extends Object>(
    Expression<T> Function($$AffectationsTableAnnotationComposer a) f,
  ) {
    final $$AffectationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.affectations,
      getReferencedColumn: (t) => t.accueillantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AffectationsTableAnnotationComposer(
            $db: $db,
            $table: $db.affectations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> preferencesAccueilRefs<T extends Object>(
    Expression<T> Function($$PreferencesAccueilTableAnnotationComposer a) f,
  ) {
    final $$PreferencesAccueilTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.preferencesAccueil,
          getReferencedColumn: (t) => t.accueillantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PreferencesAccueilTableAnnotationComposer(
                $db: $db,
                $table: $db.preferencesAccueil,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccueillantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccueillantsTable,
          Accueillant,
          $$AccueillantsTableFilterComposer,
          $$AccueillantsTableOrderingComposer,
          $$AccueillantsTableAnnotationComposer,
          $$AccueillantsTableCreateCompanionBuilder,
          $$AccueillantsTableUpdateCompanionBuilder,
          (Accueillant, $$AccueillantsTableReferences),
          Accueillant,
          PrefetchHooks Function({
            bool enfantsRefs,
            bool disponibilitesAccueilRefs,
            bool indisponibilitesRefs,
            bool affectationsRefs,
            bool preferencesAccueilRefs,
          })
        > {
  $$AccueillantsTableTableManager(_$AppDatabase db, $AccueillantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccueillantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccueillantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccueillantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> prenom = const Value.absent(),
                Value<int> nbPlaces = const Value.absent(),
                Value<String> restrictionSexe = const Value.absent(),
                Value<int?> ageMin = const Value.absent(),
                Value<int?> ageMax = const Value.absent(),
                Value<DateTime?> agrementEcheance = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => AccueillantsCompanion(
                id: id,
                nom: nom,
                prenom: prenom,
                nbPlaces: nbPlaces,
                restrictionSexe: restrictionSexe,
                ageMin: ageMin,
                ageMax: ageMax,
                agrementEcheance: agrementEcheance,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nom,
                Value<String> prenom = const Value.absent(),
                Value<int> nbPlaces = const Value.absent(),
                Value<String> restrictionSexe = const Value.absent(),
                Value<int?> ageMin = const Value.absent(),
                Value<int?> ageMax = const Value.absent(),
                Value<DateTime?> agrementEcheance = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => AccueillantsCompanion.insert(
                id: id,
                nom: nom,
                prenom: prenom,
                nbPlaces: nbPlaces,
                restrictionSexe: restrictionSexe,
                ageMin: ageMin,
                ageMax: ageMax,
                agrementEcheance: agrementEcheance,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccueillantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                enfantsRefs = false,
                disponibilitesAccueilRefs = false,
                indisponibilitesRefs = false,
                affectationsRefs = false,
                preferencesAccueilRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (enfantsRefs) db.enfants,
                    if (disponibilitesAccueilRefs) db.disponibilitesAccueil,
                    if (indisponibilitesRefs) db.indisponibilites,
                    if (affectationsRefs) db.affectations,
                    if (preferencesAccueilRefs) db.preferencesAccueil,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (enfantsRefs)
                        await $_getPrefetchedData<
                          Accueillant,
                          $AccueillantsTable,
                          Enfant
                        >(
                          currentTable: table,
                          referencedTable: $$AccueillantsTableReferences
                              ._enfantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccueillantsTableReferences(
                                db,
                                table,
                                p0,
                              ).enfantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.afHabituelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (disponibilitesAccueilRefs)
                        await $_getPrefetchedData<
                          Accueillant,
                          $AccueillantsTable,
                          DisponibiliteAccueil
                        >(
                          currentTable: table,
                          referencedTable: $$AccueillantsTableReferences
                              ._disponibilitesAccueilRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccueillantsTableReferences(
                                db,
                                table,
                                p0,
                              ).disponibilitesAccueilRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accueillantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (indisponibilitesRefs)
                        await $_getPrefetchedData<
                          Accueillant,
                          $AccueillantsTable,
                          Indisponibilite
                        >(
                          currentTable: table,
                          referencedTable: $$AccueillantsTableReferences
                              ._indisponibilitesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccueillantsTableReferences(
                                db,
                                table,
                                p0,
                              ).indisponibilitesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accueillantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (affectationsRefs)
                        await $_getPrefetchedData<
                          Accueillant,
                          $AccueillantsTable,
                          Affectation
                        >(
                          currentTable: table,
                          referencedTable: $$AccueillantsTableReferences
                              ._affectationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccueillantsTableReferences(
                                db,
                                table,
                                p0,
                              ).affectationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accueillantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (preferencesAccueilRefs)
                        await $_getPrefetchedData<
                          Accueillant,
                          $AccueillantsTable,
                          PreferenceAccueil
                        >(
                          currentTable: table,
                          referencedTable: $$AccueillantsTableReferences
                              ._preferencesAccueilRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccueillantsTableReferences(
                                db,
                                table,
                                p0,
                              ).preferencesAccueilRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accueillantId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccueillantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccueillantsTable,
      Accueillant,
      $$AccueillantsTableFilterComposer,
      $$AccueillantsTableOrderingComposer,
      $$AccueillantsTableAnnotationComposer,
      $$AccueillantsTableCreateCompanionBuilder,
      $$AccueillantsTableUpdateCompanionBuilder,
      (Accueillant, $$AccueillantsTableReferences),
      Accueillant,
      PrefetchHooks Function({
        bool enfantsRefs,
        bool disponibilitesAccueilRefs,
        bool indisponibilitesRefs,
        bool affectationsRefs,
        bool preferencesAccueilRefs,
      })
    >;
typedef $$FratriesTableCreateCompanionBuilder =
    FratriesCompanion Function({
      Value<int> id,
      required String nom,
      Value<String> regroupement,
    });
typedef $$FratriesTableUpdateCompanionBuilder =
    FratriesCompanion Function({
      Value<int> id,
      Value<String> nom,
      Value<String> regroupement,
    });

final class $$FratriesTableReferences
    extends BaseReferences<_$AppDatabase, $FratriesTable, Fratrie> {
  $$FratriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EnfantsTable, List<Enfant>> _enfantsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.enfants,
    aliasName: 'fratries__id__enfants__fratrie_id',
  );

  $$EnfantsTableProcessedTableManager get enfantsRefs {
    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.fratrieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_enfantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FratriesTableFilterComposer
    extends Composer<_$AppDatabase, $FratriesTable> {
  $$FratriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regroupement => $composableBuilder(
    column: $table.regroupement,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> enfantsRefs(
    Expression<bool> Function($$EnfantsTableFilterComposer f) f,
  ) {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.fratrieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FratriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FratriesTable> {
  $$FratriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regroupement => $composableBuilder(
    column: $table.regroupement,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FratriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FratriesTable> {
  $$FratriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get regroupement => $composableBuilder(
    column: $table.regroupement,
    builder: (column) => column,
  );

  Expression<T> enfantsRefs<T extends Object>(
    Expression<T> Function($$EnfantsTableAnnotationComposer a) f,
  ) {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.fratrieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FratriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FratriesTable,
          Fratrie,
          $$FratriesTableFilterComposer,
          $$FratriesTableOrderingComposer,
          $$FratriesTableAnnotationComposer,
          $$FratriesTableCreateCompanionBuilder,
          $$FratriesTableUpdateCompanionBuilder,
          (Fratrie, $$FratriesTableReferences),
          Fratrie,
          PrefetchHooks Function({bool enfantsRefs})
        > {
  $$FratriesTableTableManager(_$AppDatabase db, $FratriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FratriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FratriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FratriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> regroupement = const Value.absent(),
              }) => FratriesCompanion(
                id: id,
                nom: nom,
                regroupement: regroupement,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nom,
                Value<String> regroupement = const Value.absent(),
              }) => FratriesCompanion.insert(
                id: id,
                nom: nom,
                regroupement: regroupement,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FratriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({enfantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (enfantsRefs) db.enfants],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (enfantsRefs)
                    await $_getPrefetchedData<Fratrie, $FratriesTable, Enfant>(
                      currentTable: table,
                      referencedTable: $$FratriesTableReferences
                          ._enfantsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FratriesTableReferences(db, table, p0).enfantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.fratrieId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FratriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FratriesTable,
      Fratrie,
      $$FratriesTableFilterComposer,
      $$FratriesTableOrderingComposer,
      $$FratriesTableAnnotationComposer,
      $$FratriesTableCreateCompanionBuilder,
      $$FratriesTableUpdateCompanionBuilder,
      (Fratrie, $$FratriesTableReferences),
      Fratrie,
      PrefetchHooks Function({bool enfantsRefs})
    >;
typedef $$EnfantsTableCreateCompanionBuilder =
    EnfantsCompanion Function({
      Value<int> id,
      required String nom,
      Value<String> prenom,
      Value<String> sexe,
      Value<DateTime?> dateNaissance,
      Value<int?> afHabituelId,
      Value<int?> fratrieId,
      Value<String?> sante,
      Value<String?> contactUrgence,
      Value<String?> notes,
    });
typedef $$EnfantsTableUpdateCompanionBuilder =
    EnfantsCompanion Function({
      Value<int> id,
      Value<String> nom,
      Value<String> prenom,
      Value<String> sexe,
      Value<DateTime?> dateNaissance,
      Value<int?> afHabituelId,
      Value<int?> fratrieId,
      Value<String?> sante,
      Value<String?> contactUrgence,
      Value<String?> notes,
    });

final class $$EnfantsTableReferences
    extends BaseReferences<_$AppDatabase, $EnfantsTable, Enfant> {
  $$EnfantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccueillantsTable _afHabituelIdTable(_$AppDatabase db) =>
      db.accueillants.createAlias('enfants__af_habituel_id__accueillants__id');

  $$AccueillantsTableProcessedTableManager? get afHabituelId {
    final $_column = $_itemColumn<int>('af_habituel_id');
    if ($_column == null) return null;
    final manager = $$AccueillantsTableTableManager(
      $_db,
      $_db.accueillants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_afHabituelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FratriesTable _fratrieIdTable(_$AppDatabase db) =>
      db.fratries.createAlias('enfants__fratrie_id__fratries__id');

  $$FratriesTableProcessedTableManager? get fratrieId {
    final $_column = $_itemColumn<int>('fratrie_id');
    if ($_column == null) return null;
    final manager = $$FratriesTableTableManager(
      $_db,
      $_db.fratries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fratrieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BesoinsRelaisTable, List<BesoinRelais>>
  _besoinsRelaisRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.besoinsRelais,
    aliasName: 'enfants__id__besoins_relais__enfant_id',
  );

  $$BesoinsRelaisTableProcessedTableManager get besoinsRelaisRefs {
    final manager = $$BesoinsRelaisTableTableManager(
      $_db,
      $_db.besoinsRelais,
    ).filter((f) => f.enfantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_besoinsRelaisRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AffectationsTable, List<Affectation>>
  _affectationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.affectations,
    aliasName: 'enfants__id__affectations__enfant_id',
  );

  $$AffectationsTableProcessedTableManager get affectationsRefs {
    final manager = $$AffectationsTableTableManager(
      $_db,
      $_db.affectations,
    ).filter((f) => f.enfantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_affectationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PreferencesAccueilTable, List<PreferenceAccueil>>
  _preferencesAccueilRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.preferencesAccueil,
        aliasName: 'enfants__id__preferences_accueil__enfant_id',
      );

  $$PreferencesAccueilTableProcessedTableManager get preferencesAccueilRefs {
    final manager = $$PreferencesAccueilTableTableManager(
      $_db,
      $_db.preferencesAccueil,
    ).filter((f) => f.enfantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _preferencesAccueilRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SolutionsAlternativesTable,
    List<SolutionAlternative>
  >
  _solutionsAlternativesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.solutionsAlternatives,
        aliasName: 'enfants__id__solutions_alternatives__enfant_id',
      );

  $$SolutionsAlternativesTableProcessedTableManager
  get solutionsAlternativesRefs {
    final manager = $$SolutionsAlternativesTableTableManager(
      $_db,
      $_db.solutionsAlternatives,
    ).filter((f) => f.enfantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _solutionsAlternativesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EnfantsTableFilterComposer
    extends Composer<_$AppDatabase, $EnfantsTable> {
  $$EnfantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sexe => $composableBuilder(
    column: $table.sexe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sante => $composableBuilder(
    column: $table.sante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactUrgence => $composableBuilder(
    column: $table.contactUrgence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$AccueillantsTableFilterComposer get afHabituelId {
    final $$AccueillantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.afHabituelId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableFilterComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FratriesTableFilterComposer get fratrieId {
    final $$FratriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fratrieId,
      referencedTable: $db.fratries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FratriesTableFilterComposer(
            $db: $db,
            $table: $db.fratries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> besoinsRelaisRefs(
    Expression<bool> Function($$BesoinsRelaisTableFilterComposer f) f,
  ) {
    final $$BesoinsRelaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.besoinsRelais,
      getReferencedColumn: (t) => t.enfantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BesoinsRelaisTableFilterComposer(
            $db: $db,
            $table: $db.besoinsRelais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> affectationsRefs(
    Expression<bool> Function($$AffectationsTableFilterComposer f) f,
  ) {
    final $$AffectationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.affectations,
      getReferencedColumn: (t) => t.enfantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AffectationsTableFilterComposer(
            $db: $db,
            $table: $db.affectations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> preferencesAccueilRefs(
    Expression<bool> Function($$PreferencesAccueilTableFilterComposer f) f,
  ) {
    final $$PreferencesAccueilTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preferencesAccueil,
      getReferencedColumn: (t) => t.enfantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreferencesAccueilTableFilterComposer(
            $db: $db,
            $table: $db.preferencesAccueil,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> solutionsAlternativesRefs(
    Expression<bool> Function($$SolutionsAlternativesTableFilterComposer f) f,
  ) {
    final $$SolutionsAlternativesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.solutionsAlternatives,
          getReferencedColumn: (t) => t.enfantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SolutionsAlternativesTableFilterComposer(
                $db: $db,
                $table: $db.solutionsAlternatives,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EnfantsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnfantsTable> {
  $$EnfantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sexe => $composableBuilder(
    column: $table.sexe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sante => $composableBuilder(
    column: $table.sante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactUrgence => $composableBuilder(
    column: $table.contactUrgence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccueillantsTableOrderingComposer get afHabituelId {
    final $$AccueillantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.afHabituelId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableOrderingComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FratriesTableOrderingComposer get fratrieId {
    final $$FratriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fratrieId,
      referencedTable: $db.fratries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FratriesTableOrderingComposer(
            $db: $db,
            $table: $db.fratries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnfantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnfantsTable> {
  $$EnfantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get sexe =>
      $composableBuilder(column: $table.sexe, builder: (column) => column);

  GeneratedColumn<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sante =>
      $composableBuilder(column: $table.sante, builder: (column) => column);

  GeneratedColumn<String> get contactUrgence => $composableBuilder(
    column: $table.contactUrgence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$AccueillantsTableAnnotationComposer get afHabituelId {
    final $$AccueillantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.afHabituelId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableAnnotationComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FratriesTableAnnotationComposer get fratrieId {
    final $$FratriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fratrieId,
      referencedTable: $db.fratries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FratriesTableAnnotationComposer(
            $db: $db,
            $table: $db.fratries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> besoinsRelaisRefs<T extends Object>(
    Expression<T> Function($$BesoinsRelaisTableAnnotationComposer a) f,
  ) {
    final $$BesoinsRelaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.besoinsRelais,
      getReferencedColumn: (t) => t.enfantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BesoinsRelaisTableAnnotationComposer(
            $db: $db,
            $table: $db.besoinsRelais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> affectationsRefs<T extends Object>(
    Expression<T> Function($$AffectationsTableAnnotationComposer a) f,
  ) {
    final $$AffectationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.affectations,
      getReferencedColumn: (t) => t.enfantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AffectationsTableAnnotationComposer(
            $db: $db,
            $table: $db.affectations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> preferencesAccueilRefs<T extends Object>(
    Expression<T> Function($$PreferencesAccueilTableAnnotationComposer a) f,
  ) {
    final $$PreferencesAccueilTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.preferencesAccueil,
          getReferencedColumn: (t) => t.enfantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PreferencesAccueilTableAnnotationComposer(
                $db: $db,
                $table: $db.preferencesAccueil,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> solutionsAlternativesRefs<T extends Object>(
    Expression<T> Function($$SolutionsAlternativesTableAnnotationComposer a) f,
  ) {
    final $$SolutionsAlternativesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.solutionsAlternatives,
          getReferencedColumn: (t) => t.enfantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SolutionsAlternativesTableAnnotationComposer(
                $db: $db,
                $table: $db.solutionsAlternatives,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EnfantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnfantsTable,
          Enfant,
          $$EnfantsTableFilterComposer,
          $$EnfantsTableOrderingComposer,
          $$EnfantsTableAnnotationComposer,
          $$EnfantsTableCreateCompanionBuilder,
          $$EnfantsTableUpdateCompanionBuilder,
          (Enfant, $$EnfantsTableReferences),
          Enfant,
          PrefetchHooks Function({
            bool afHabituelId,
            bool fratrieId,
            bool besoinsRelaisRefs,
            bool affectationsRefs,
            bool preferencesAccueilRefs,
            bool solutionsAlternativesRefs,
          })
        > {
  $$EnfantsTableTableManager(_$AppDatabase db, $EnfantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnfantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnfantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnfantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> prenom = const Value.absent(),
                Value<String> sexe = const Value.absent(),
                Value<DateTime?> dateNaissance = const Value.absent(),
                Value<int?> afHabituelId = const Value.absent(),
                Value<int?> fratrieId = const Value.absent(),
                Value<String?> sante = const Value.absent(),
                Value<String?> contactUrgence = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => EnfantsCompanion(
                id: id,
                nom: nom,
                prenom: prenom,
                sexe: sexe,
                dateNaissance: dateNaissance,
                afHabituelId: afHabituelId,
                fratrieId: fratrieId,
                sante: sante,
                contactUrgence: contactUrgence,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nom,
                Value<String> prenom = const Value.absent(),
                Value<String> sexe = const Value.absent(),
                Value<DateTime?> dateNaissance = const Value.absent(),
                Value<int?> afHabituelId = const Value.absent(),
                Value<int?> fratrieId = const Value.absent(),
                Value<String?> sante = const Value.absent(),
                Value<String?> contactUrgence = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => EnfantsCompanion.insert(
                id: id,
                nom: nom,
                prenom: prenom,
                sexe: sexe,
                dateNaissance: dateNaissance,
                afHabituelId: afHabituelId,
                fratrieId: fratrieId,
                sante: sante,
                contactUrgence: contactUrgence,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnfantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                afHabituelId = false,
                fratrieId = false,
                besoinsRelaisRefs = false,
                affectationsRefs = false,
                preferencesAccueilRefs = false,
                solutionsAlternativesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (besoinsRelaisRefs) db.besoinsRelais,
                    if (affectationsRefs) db.affectations,
                    if (preferencesAccueilRefs) db.preferencesAccueil,
                    if (solutionsAlternativesRefs) db.solutionsAlternatives,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (afHabituelId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.afHabituelId,
                                    referencedTable: $$EnfantsTableReferences
                                        ._afHabituelIdTable(db),
                                    referencedColumn: $$EnfantsTableReferences
                                        ._afHabituelIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (fratrieId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fratrieId,
                                    referencedTable: $$EnfantsTableReferences
                                        ._fratrieIdTable(db),
                                    referencedColumn: $$EnfantsTableReferences
                                        ._fratrieIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (besoinsRelaisRefs)
                        await $_getPrefetchedData<
                          Enfant,
                          $EnfantsTable,
                          BesoinRelais
                        >(
                          currentTable: table,
                          referencedTable: $$EnfantsTableReferences
                              ._besoinsRelaisRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnfantsTableReferences(
                                db,
                                table,
                                p0,
                              ).besoinsRelaisRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.enfantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (affectationsRefs)
                        await $_getPrefetchedData<
                          Enfant,
                          $EnfantsTable,
                          Affectation
                        >(
                          currentTable: table,
                          referencedTable: $$EnfantsTableReferences
                              ._affectationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnfantsTableReferences(
                                db,
                                table,
                                p0,
                              ).affectationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.enfantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (preferencesAccueilRefs)
                        await $_getPrefetchedData<
                          Enfant,
                          $EnfantsTable,
                          PreferenceAccueil
                        >(
                          currentTable: table,
                          referencedTable: $$EnfantsTableReferences
                              ._preferencesAccueilRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnfantsTableReferences(
                                db,
                                table,
                                p0,
                              ).preferencesAccueilRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.enfantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (solutionsAlternativesRefs)
                        await $_getPrefetchedData<
                          Enfant,
                          $EnfantsTable,
                          SolutionAlternative
                        >(
                          currentTable: table,
                          referencedTable: $$EnfantsTableReferences
                              ._solutionsAlternativesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnfantsTableReferences(
                                db,
                                table,
                                p0,
                              ).solutionsAlternativesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.enfantId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EnfantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnfantsTable,
      Enfant,
      $$EnfantsTableFilterComposer,
      $$EnfantsTableOrderingComposer,
      $$EnfantsTableAnnotationComposer,
      $$EnfantsTableCreateCompanionBuilder,
      $$EnfantsTableUpdateCompanionBuilder,
      (Enfant, $$EnfantsTableReferences),
      Enfant,
      PrefetchHooks Function({
        bool afHabituelId,
        bool fratrieId,
        bool besoinsRelaisRefs,
        bool affectationsRefs,
        bool preferencesAccueilRefs,
        bool solutionsAlternativesRefs,
      })
    >;
typedef $$DisponibilitesAccueilTableCreateCompanionBuilder =
    DisponibilitesAccueilCompanion Function({
      Value<int> id,
      required int accueillantId,
      required DateTime debut,
      required DateTime fin,
    });
typedef $$DisponibilitesAccueilTableUpdateCompanionBuilder =
    DisponibilitesAccueilCompanion Function({
      Value<int> id,
      Value<int> accueillantId,
      Value<DateTime> debut,
      Value<DateTime> fin,
    });

final class $$DisponibilitesAccueilTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DisponibilitesAccueilTable,
          DisponibiliteAccueil
        > {
  $$DisponibilitesAccueilTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccueillantsTable _accueillantIdTable(_$AppDatabase db) => db
      .accueillants
      .createAlias('disponibilites_accueil__accueillant_id__accueillants__id');

  $$AccueillantsTableProcessedTableManager get accueillantId {
    final $_column = $_itemColumn<int>('accueillant_id')!;

    final manager = $$AccueillantsTableTableManager(
      $_db,
      $_db.accueillants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accueillantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DisponibilitesAccueilTableFilterComposer
    extends Composer<_$AppDatabase, $DisponibilitesAccueilTable> {
  $$DisponibilitesAccueilTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnFilters(column),
  );

  $$AccueillantsTableFilterComposer get accueillantId {
    final $$AccueillantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableFilterComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DisponibilitesAccueilTableOrderingComposer
    extends Composer<_$AppDatabase, $DisponibilitesAccueilTable> {
  $$DisponibilitesAccueilTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccueillantsTableOrderingComposer get accueillantId {
    final $$AccueillantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableOrderingComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DisponibilitesAccueilTableAnnotationComposer
    extends Composer<_$AppDatabase, $DisponibilitesAccueilTable> {
  $$DisponibilitesAccueilTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get debut =>
      $composableBuilder(column: $table.debut, builder: (column) => column);

  GeneratedColumn<DateTime> get fin =>
      $composableBuilder(column: $table.fin, builder: (column) => column);

  $$AccueillantsTableAnnotationComposer get accueillantId {
    final $$AccueillantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableAnnotationComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DisponibilitesAccueilTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DisponibilitesAccueilTable,
          DisponibiliteAccueil,
          $$DisponibilitesAccueilTableFilterComposer,
          $$DisponibilitesAccueilTableOrderingComposer,
          $$DisponibilitesAccueilTableAnnotationComposer,
          $$DisponibilitesAccueilTableCreateCompanionBuilder,
          $$DisponibilitesAccueilTableUpdateCompanionBuilder,
          (DisponibiliteAccueil, $$DisponibilitesAccueilTableReferences),
          DisponibiliteAccueil,
          PrefetchHooks Function({bool accueillantId})
        > {
  $$DisponibilitesAccueilTableTableManager(
    _$AppDatabase db,
    $DisponibilitesAccueilTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DisponibilitesAccueilTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DisponibilitesAccueilTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DisponibilitesAccueilTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accueillantId = const Value.absent(),
                Value<DateTime> debut = const Value.absent(),
                Value<DateTime> fin = const Value.absent(),
              }) => DisponibilitesAccueilCompanion(
                id: id,
                accueillantId: accueillantId,
                debut: debut,
                fin: fin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accueillantId,
                required DateTime debut,
                required DateTime fin,
              }) => DisponibilitesAccueilCompanion.insert(
                id: id,
                accueillantId: accueillantId,
                debut: debut,
                fin: fin,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DisponibilitesAccueilTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accueillantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accueillantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accueillantId,
                                referencedTable:
                                    $$DisponibilitesAccueilTableReferences
                                        ._accueillantIdTable(db),
                                referencedColumn:
                                    $$DisponibilitesAccueilTableReferences
                                        ._accueillantIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DisponibilitesAccueilTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DisponibilitesAccueilTable,
      DisponibiliteAccueil,
      $$DisponibilitesAccueilTableFilterComposer,
      $$DisponibilitesAccueilTableOrderingComposer,
      $$DisponibilitesAccueilTableAnnotationComposer,
      $$DisponibilitesAccueilTableCreateCompanionBuilder,
      $$DisponibilitesAccueilTableUpdateCompanionBuilder,
      (DisponibiliteAccueil, $$DisponibilitesAccueilTableReferences),
      DisponibiliteAccueil,
      PrefetchHooks Function({bool accueillantId})
    >;
typedef $$IndisponibilitesTableCreateCompanionBuilder =
    IndisponibilitesCompanion Function({
      Value<int> id,
      required int accueillantId,
      required DateTime debut,
      required DateTime fin,
      Value<String?> motif,
    });
typedef $$IndisponibilitesTableUpdateCompanionBuilder =
    IndisponibilitesCompanion Function({
      Value<int> id,
      Value<int> accueillantId,
      Value<DateTime> debut,
      Value<DateTime> fin,
      Value<String?> motif,
    });

final class $$IndisponibilitesTableReferences
    extends
        BaseReferences<_$AppDatabase, $IndisponibilitesTable, Indisponibilite> {
  $$IndisponibilitesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccueillantsTable _accueillantIdTable(_$AppDatabase db) => db
      .accueillants
      .createAlias('indisponibilites__accueillant_id__accueillants__id');

  $$AccueillantsTableProcessedTableManager get accueillantId {
    final $_column = $_itemColumn<int>('accueillant_id')!;

    final manager = $$AccueillantsTableTableManager(
      $_db,
      $_db.accueillants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accueillantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IndisponibilitesTableFilterComposer
    extends Composer<_$AppDatabase, $IndisponibilitesTable> {
  $$IndisponibilitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motif => $composableBuilder(
    column: $table.motif,
    builder: (column) => ColumnFilters(column),
  );

  $$AccueillantsTableFilterComposer get accueillantId {
    final $$AccueillantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableFilterComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IndisponibilitesTableOrderingComposer
    extends Composer<_$AppDatabase, $IndisponibilitesTable> {
  $$IndisponibilitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motif => $composableBuilder(
    column: $table.motif,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccueillantsTableOrderingComposer get accueillantId {
    final $$AccueillantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableOrderingComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IndisponibilitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndisponibilitesTable> {
  $$IndisponibilitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get debut =>
      $composableBuilder(column: $table.debut, builder: (column) => column);

  GeneratedColumn<DateTime> get fin =>
      $composableBuilder(column: $table.fin, builder: (column) => column);

  GeneratedColumn<String> get motif =>
      $composableBuilder(column: $table.motif, builder: (column) => column);

  $$AccueillantsTableAnnotationComposer get accueillantId {
    final $$AccueillantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableAnnotationComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IndisponibilitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IndisponibilitesTable,
          Indisponibilite,
          $$IndisponibilitesTableFilterComposer,
          $$IndisponibilitesTableOrderingComposer,
          $$IndisponibilitesTableAnnotationComposer,
          $$IndisponibilitesTableCreateCompanionBuilder,
          $$IndisponibilitesTableUpdateCompanionBuilder,
          (Indisponibilite, $$IndisponibilitesTableReferences),
          Indisponibilite,
          PrefetchHooks Function({bool accueillantId})
        > {
  $$IndisponibilitesTableTableManager(
    _$AppDatabase db,
    $IndisponibilitesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndisponibilitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndisponibilitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndisponibilitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accueillantId = const Value.absent(),
                Value<DateTime> debut = const Value.absent(),
                Value<DateTime> fin = const Value.absent(),
                Value<String?> motif = const Value.absent(),
              }) => IndisponibilitesCompanion(
                id: id,
                accueillantId: accueillantId,
                debut: debut,
                fin: fin,
                motif: motif,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accueillantId,
                required DateTime debut,
                required DateTime fin,
                Value<String?> motif = const Value.absent(),
              }) => IndisponibilitesCompanion.insert(
                id: id,
                accueillantId: accueillantId,
                debut: debut,
                fin: fin,
                motif: motif,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IndisponibilitesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accueillantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accueillantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accueillantId,
                                referencedTable:
                                    $$IndisponibilitesTableReferences
                                        ._accueillantIdTable(db),
                                referencedColumn:
                                    $$IndisponibilitesTableReferences
                                        ._accueillantIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IndisponibilitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IndisponibilitesTable,
      Indisponibilite,
      $$IndisponibilitesTableFilterComposer,
      $$IndisponibilitesTableOrderingComposer,
      $$IndisponibilitesTableAnnotationComposer,
      $$IndisponibilitesTableCreateCompanionBuilder,
      $$IndisponibilitesTableUpdateCompanionBuilder,
      (Indisponibilite, $$IndisponibilitesTableReferences),
      Indisponibilite,
      PrefetchHooks Function({bool accueillantId})
    >;
typedef $$BesoinsRelaisTableCreateCompanionBuilder =
    BesoinsRelaisCompanion Function({
      Value<int> id,
      required int enfantId,
      required DateTime debut,
      required DateTime fin,
      Value<String?> motif,
    });
typedef $$BesoinsRelaisTableUpdateCompanionBuilder =
    BesoinsRelaisCompanion Function({
      Value<int> id,
      Value<int> enfantId,
      Value<DateTime> debut,
      Value<DateTime> fin,
      Value<String?> motif,
    });

final class $$BesoinsRelaisTableReferences
    extends BaseReferences<_$AppDatabase, $BesoinsRelaisTable, BesoinRelais> {
  $$BesoinsRelaisTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnfantsTable _enfantIdTable(_$AppDatabase db) =>
      db.enfants.createAlias('besoins_relais__enfant_id__enfants__id');

  $$EnfantsTableProcessedTableManager get enfantId {
    final $_column = $_itemColumn<int>('enfant_id')!;

    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enfantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AffectationsTable, List<Affectation>>
  _affectationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.affectations,
    aliasName: 'besoins_relais__id__affectations__besoin_id',
  );

  $$AffectationsTableProcessedTableManager get affectationsRefs {
    final manager = $$AffectationsTableTableManager(
      $_db,
      $_db.affectations,
    ).filter((f) => f.besoinId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_affectationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BesoinsRelaisTableFilterComposer
    extends Composer<_$AppDatabase, $BesoinsRelaisTable> {
  $$BesoinsRelaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motif => $composableBuilder(
    column: $table.motif,
    builder: (column) => ColumnFilters(column),
  );

  $$EnfantsTableFilterComposer get enfantId {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> affectationsRefs(
    Expression<bool> Function($$AffectationsTableFilterComposer f) f,
  ) {
    final $$AffectationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.affectations,
      getReferencedColumn: (t) => t.besoinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AffectationsTableFilterComposer(
            $db: $db,
            $table: $db.affectations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BesoinsRelaisTableOrderingComposer
    extends Composer<_$AppDatabase, $BesoinsRelaisTable> {
  $$BesoinsRelaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motif => $composableBuilder(
    column: $table.motif,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnfantsTableOrderingComposer get enfantId {
    final $$EnfantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableOrderingComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BesoinsRelaisTableAnnotationComposer
    extends Composer<_$AppDatabase, $BesoinsRelaisTable> {
  $$BesoinsRelaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get debut =>
      $composableBuilder(column: $table.debut, builder: (column) => column);

  GeneratedColumn<DateTime> get fin =>
      $composableBuilder(column: $table.fin, builder: (column) => column);

  GeneratedColumn<String> get motif =>
      $composableBuilder(column: $table.motif, builder: (column) => column);

  $$EnfantsTableAnnotationComposer get enfantId {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> affectationsRefs<T extends Object>(
    Expression<T> Function($$AffectationsTableAnnotationComposer a) f,
  ) {
    final $$AffectationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.affectations,
      getReferencedColumn: (t) => t.besoinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AffectationsTableAnnotationComposer(
            $db: $db,
            $table: $db.affectations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BesoinsRelaisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BesoinsRelaisTable,
          BesoinRelais,
          $$BesoinsRelaisTableFilterComposer,
          $$BesoinsRelaisTableOrderingComposer,
          $$BesoinsRelaisTableAnnotationComposer,
          $$BesoinsRelaisTableCreateCompanionBuilder,
          $$BesoinsRelaisTableUpdateCompanionBuilder,
          (BesoinRelais, $$BesoinsRelaisTableReferences),
          BesoinRelais,
          PrefetchHooks Function({bool enfantId, bool affectationsRefs})
        > {
  $$BesoinsRelaisTableTableManager(_$AppDatabase db, $BesoinsRelaisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BesoinsRelaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BesoinsRelaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BesoinsRelaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> enfantId = const Value.absent(),
                Value<DateTime> debut = const Value.absent(),
                Value<DateTime> fin = const Value.absent(),
                Value<String?> motif = const Value.absent(),
              }) => BesoinsRelaisCompanion(
                id: id,
                enfantId: enfantId,
                debut: debut,
                fin: fin,
                motif: motif,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int enfantId,
                required DateTime debut,
                required DateTime fin,
                Value<String?> motif = const Value.absent(),
              }) => BesoinsRelaisCompanion.insert(
                id: id,
                enfantId: enfantId,
                debut: debut,
                fin: fin,
                motif: motif,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BesoinsRelaisTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({enfantId = false, affectationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (affectationsRefs) db.affectations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (enfantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.enfantId,
                                    referencedTable:
                                        $$BesoinsRelaisTableReferences
                                            ._enfantIdTable(db),
                                    referencedColumn:
                                        $$BesoinsRelaisTableReferences
                                            ._enfantIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (affectationsRefs)
                        await $_getPrefetchedData<
                          BesoinRelais,
                          $BesoinsRelaisTable,
                          Affectation
                        >(
                          currentTable: table,
                          referencedTable: $$BesoinsRelaisTableReferences
                              ._affectationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BesoinsRelaisTableReferences(
                                db,
                                table,
                                p0,
                              ).affectationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.besoinId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BesoinsRelaisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BesoinsRelaisTable,
      BesoinRelais,
      $$BesoinsRelaisTableFilterComposer,
      $$BesoinsRelaisTableOrderingComposer,
      $$BesoinsRelaisTableAnnotationComposer,
      $$BesoinsRelaisTableCreateCompanionBuilder,
      $$BesoinsRelaisTableUpdateCompanionBuilder,
      (BesoinRelais, $$BesoinsRelaisTableReferences),
      BesoinRelais,
      PrefetchHooks Function({bool enfantId, bool affectationsRefs})
    >;
typedef $$AffectationsTableCreateCompanionBuilder =
    AffectationsCompanion Function({
      Value<int> id,
      required int enfantId,
      required int accueillantId,
      required DateTime debut,
      required DateTime fin,
      Value<int?> besoinId,
      Value<String> statut,
    });
typedef $$AffectationsTableUpdateCompanionBuilder =
    AffectationsCompanion Function({
      Value<int> id,
      Value<int> enfantId,
      Value<int> accueillantId,
      Value<DateTime> debut,
      Value<DateTime> fin,
      Value<int?> besoinId,
      Value<String> statut,
    });

final class $$AffectationsTableReferences
    extends BaseReferences<_$AppDatabase, $AffectationsTable, Affectation> {
  $$AffectationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EnfantsTable _enfantIdTable(_$AppDatabase db) =>
      db.enfants.createAlias('affectations__enfant_id__enfants__id');

  $$EnfantsTableProcessedTableManager get enfantId {
    final $_column = $_itemColumn<int>('enfant_id')!;

    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enfantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccueillantsTable _accueillantIdTable(_$AppDatabase db) => db
      .accueillants
      .createAlias('affectations__accueillant_id__accueillants__id');

  $$AccueillantsTableProcessedTableManager get accueillantId {
    final $_column = $_itemColumn<int>('accueillant_id')!;

    final manager = $$AccueillantsTableTableManager(
      $_db,
      $_db.accueillants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accueillantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BesoinsRelaisTable _besoinIdTable(_$AppDatabase db) => db
      .besoinsRelais
      .createAlias('affectations__besoin_id__besoins_relais__id');

  $$BesoinsRelaisTableProcessedTableManager? get besoinId {
    final $_column = $_itemColumn<int>('besoin_id');
    if ($_column == null) return null;
    final manager = $$BesoinsRelaisTableTableManager(
      $_db,
      $_db.besoinsRelais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_besoinIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AffectationsTableFilterComposer
    extends Composer<_$AppDatabase, $AffectationsTable> {
  $$AffectationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnFilters(column),
  );

  $$EnfantsTableFilterComposer get enfantId {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccueillantsTableFilterComposer get accueillantId {
    final $$AccueillantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableFilterComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BesoinsRelaisTableFilterComposer get besoinId {
    final $$BesoinsRelaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.besoinId,
      referencedTable: $db.besoinsRelais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BesoinsRelaisTableFilterComposer(
            $db: $db,
            $table: $db.besoinsRelais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AffectationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AffectationsTable> {
  $$AffectationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnfantsTableOrderingComposer get enfantId {
    final $$EnfantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableOrderingComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccueillantsTableOrderingComposer get accueillantId {
    final $$AccueillantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableOrderingComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BesoinsRelaisTableOrderingComposer get besoinId {
    final $$BesoinsRelaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.besoinId,
      referencedTable: $db.besoinsRelais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BesoinsRelaisTableOrderingComposer(
            $db: $db,
            $table: $db.besoinsRelais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AffectationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AffectationsTable> {
  $$AffectationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get debut =>
      $composableBuilder(column: $table.debut, builder: (column) => column);

  GeneratedColumn<DateTime> get fin =>
      $composableBuilder(column: $table.fin, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  $$EnfantsTableAnnotationComposer get enfantId {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccueillantsTableAnnotationComposer get accueillantId {
    final $$AccueillantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableAnnotationComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BesoinsRelaisTableAnnotationComposer get besoinId {
    final $$BesoinsRelaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.besoinId,
      referencedTable: $db.besoinsRelais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BesoinsRelaisTableAnnotationComposer(
            $db: $db,
            $table: $db.besoinsRelais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AffectationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AffectationsTable,
          Affectation,
          $$AffectationsTableFilterComposer,
          $$AffectationsTableOrderingComposer,
          $$AffectationsTableAnnotationComposer,
          $$AffectationsTableCreateCompanionBuilder,
          $$AffectationsTableUpdateCompanionBuilder,
          (Affectation, $$AffectationsTableReferences),
          Affectation,
          PrefetchHooks Function({
            bool enfantId,
            bool accueillantId,
            bool besoinId,
          })
        > {
  $$AffectationsTableTableManager(_$AppDatabase db, $AffectationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AffectationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AffectationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AffectationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> enfantId = const Value.absent(),
                Value<int> accueillantId = const Value.absent(),
                Value<DateTime> debut = const Value.absent(),
                Value<DateTime> fin = const Value.absent(),
                Value<int?> besoinId = const Value.absent(),
                Value<String> statut = const Value.absent(),
              }) => AffectationsCompanion(
                id: id,
                enfantId: enfantId,
                accueillantId: accueillantId,
                debut: debut,
                fin: fin,
                besoinId: besoinId,
                statut: statut,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int enfantId,
                required int accueillantId,
                required DateTime debut,
                required DateTime fin,
                Value<int?> besoinId = const Value.absent(),
                Value<String> statut = const Value.absent(),
              }) => AffectationsCompanion.insert(
                id: id,
                enfantId: enfantId,
                accueillantId: accueillantId,
                debut: debut,
                fin: fin,
                besoinId: besoinId,
                statut: statut,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AffectationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({enfantId = false, accueillantId = false, besoinId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (enfantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.enfantId,
                                    referencedTable:
                                        $$AffectationsTableReferences
                                            ._enfantIdTable(db),
                                    referencedColumn:
                                        $$AffectationsTableReferences
                                            ._enfantIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (accueillantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accueillantId,
                                    referencedTable:
                                        $$AffectationsTableReferences
                                            ._accueillantIdTable(db),
                                    referencedColumn:
                                        $$AffectationsTableReferences
                                            ._accueillantIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (besoinId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.besoinId,
                                    referencedTable:
                                        $$AffectationsTableReferences
                                            ._besoinIdTable(db),
                                    referencedColumn:
                                        $$AffectationsTableReferences
                                            ._besoinIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AffectationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AffectationsTable,
      Affectation,
      $$AffectationsTableFilterComposer,
      $$AffectationsTableOrderingComposer,
      $$AffectationsTableAnnotationComposer,
      $$AffectationsTableCreateCompanionBuilder,
      $$AffectationsTableUpdateCompanionBuilder,
      (Affectation, $$AffectationsTableReferences),
      Affectation,
      PrefetchHooks Function({bool enfantId, bool accueillantId, bool besoinId})
    >;
typedef $$IncompatibilitesTableCreateCompanionBuilder =
    IncompatibilitesCompanion Function({
      Value<int> id,
      required int enfantAId,
      required int enfantBId,
    });
typedef $$IncompatibilitesTableUpdateCompanionBuilder =
    IncompatibilitesCompanion Function({
      Value<int> id,
      Value<int> enfantAId,
      Value<int> enfantBId,
    });

final class $$IncompatibilitesTableReferences
    extends
        BaseReferences<_$AppDatabase, $IncompatibilitesTable, Incompatibilite> {
  $$IncompatibilitesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnfantsTable _enfantAIdTable(_$AppDatabase db) =>
      db.enfants.createAlias('incompatibilites__enfant_a_id__enfants__id');

  $$EnfantsTableProcessedTableManager get enfantAId {
    final $_column = $_itemColumn<int>('enfant_a_id')!;

    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enfantAIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EnfantsTable _enfantBIdTable(_$AppDatabase db) =>
      db.enfants.createAlias('incompatibilites__enfant_b_id__enfants__id');

  $$EnfantsTableProcessedTableManager get enfantBId {
    final $_column = $_itemColumn<int>('enfant_b_id')!;

    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enfantBIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IncompatibilitesTableFilterComposer
    extends Composer<_$AppDatabase, $IncompatibilitesTable> {
  $$IncompatibilitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$EnfantsTableFilterComposer get enfantAId {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantAId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnfantsTableFilterComposer get enfantBId {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantBId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncompatibilitesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncompatibilitesTable> {
  $$IncompatibilitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnfantsTableOrderingComposer get enfantAId {
    final $$EnfantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantAId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableOrderingComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnfantsTableOrderingComposer get enfantBId {
    final $$EnfantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantBId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableOrderingComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncompatibilitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncompatibilitesTable> {
  $$IncompatibilitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$EnfantsTableAnnotationComposer get enfantAId {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantAId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnfantsTableAnnotationComposer get enfantBId {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantBId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncompatibilitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncompatibilitesTable,
          Incompatibilite,
          $$IncompatibilitesTableFilterComposer,
          $$IncompatibilitesTableOrderingComposer,
          $$IncompatibilitesTableAnnotationComposer,
          $$IncompatibilitesTableCreateCompanionBuilder,
          $$IncompatibilitesTableUpdateCompanionBuilder,
          (Incompatibilite, $$IncompatibilitesTableReferences),
          Incompatibilite,
          PrefetchHooks Function({bool enfantAId, bool enfantBId})
        > {
  $$IncompatibilitesTableTableManager(
    _$AppDatabase db,
    $IncompatibilitesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncompatibilitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncompatibilitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncompatibilitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> enfantAId = const Value.absent(),
                Value<int> enfantBId = const Value.absent(),
              }) => IncompatibilitesCompanion(
                id: id,
                enfantAId: enfantAId,
                enfantBId: enfantBId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int enfantAId,
                required int enfantBId,
              }) => IncompatibilitesCompanion.insert(
                id: id,
                enfantAId: enfantAId,
                enfantBId: enfantBId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncompatibilitesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({enfantAId = false, enfantBId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (enfantAId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.enfantAId,
                                referencedTable:
                                    $$IncompatibilitesTableReferences
                                        ._enfantAIdTable(db),
                                referencedColumn:
                                    $$IncompatibilitesTableReferences
                                        ._enfantAIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (enfantBId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.enfantBId,
                                referencedTable:
                                    $$IncompatibilitesTableReferences
                                        ._enfantBIdTable(db),
                                referencedColumn:
                                    $$IncompatibilitesTableReferences
                                        ._enfantBIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IncompatibilitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncompatibilitesTable,
      Incompatibilite,
      $$IncompatibilitesTableFilterComposer,
      $$IncompatibilitesTableOrderingComposer,
      $$IncompatibilitesTableAnnotationComposer,
      $$IncompatibilitesTableCreateCompanionBuilder,
      $$IncompatibilitesTableUpdateCompanionBuilder,
      (Incompatibilite, $$IncompatibilitesTableReferences),
      Incompatibilite,
      PrefetchHooks Function({bool enfantAId, bool enfantBId})
    >;
typedef $$PreferencesAccueilTableCreateCompanionBuilder =
    PreferencesAccueilCompanion Function({
      Value<int> id,
      required int enfantId,
      required int accueillantId,
      required String type,
    });
typedef $$PreferencesAccueilTableUpdateCompanionBuilder =
    PreferencesAccueilCompanion Function({
      Value<int> id,
      Value<int> enfantId,
      Value<int> accueillantId,
      Value<String> type,
    });

final class $$PreferencesAccueilTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PreferencesAccueilTable,
          PreferenceAccueil
        > {
  $$PreferencesAccueilTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnfantsTable _enfantIdTable(_$AppDatabase db) =>
      db.enfants.createAlias('preferences_accueil__enfant_id__enfants__id');

  $$EnfantsTableProcessedTableManager get enfantId {
    final $_column = $_itemColumn<int>('enfant_id')!;

    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enfantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccueillantsTable _accueillantIdTable(_$AppDatabase db) => db
      .accueillants
      .createAlias('preferences_accueil__accueillant_id__accueillants__id');

  $$AccueillantsTableProcessedTableManager get accueillantId {
    final $_column = $_itemColumn<int>('accueillant_id')!;

    final manager = $$AccueillantsTableTableManager(
      $_db,
      $_db.accueillants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accueillantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PreferencesAccueilTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesAccueilTable> {
  $$PreferencesAccueilTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $$EnfantsTableFilterComposer get enfantId {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccueillantsTableFilterComposer get accueillantId {
    final $$AccueillantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableFilterComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreferencesAccueilTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesAccueilTable> {
  $$PreferencesAccueilTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnfantsTableOrderingComposer get enfantId {
    final $$EnfantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableOrderingComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccueillantsTableOrderingComposer get accueillantId {
    final $$AccueillantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableOrderingComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreferencesAccueilTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesAccueilTable> {
  $$PreferencesAccueilTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$EnfantsTableAnnotationComposer get enfantId {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccueillantsTableAnnotationComposer get accueillantId {
    final $$AccueillantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accueillantId,
      referencedTable: $db.accueillants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccueillantsTableAnnotationComposer(
            $db: $db,
            $table: $db.accueillants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreferencesAccueilTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesAccueilTable,
          PreferenceAccueil,
          $$PreferencesAccueilTableFilterComposer,
          $$PreferencesAccueilTableOrderingComposer,
          $$PreferencesAccueilTableAnnotationComposer,
          $$PreferencesAccueilTableCreateCompanionBuilder,
          $$PreferencesAccueilTableUpdateCompanionBuilder,
          (PreferenceAccueil, $$PreferencesAccueilTableReferences),
          PreferenceAccueil,
          PrefetchHooks Function({bool enfantId, bool accueillantId})
        > {
  $$PreferencesAccueilTableTableManager(
    _$AppDatabase db,
    $PreferencesAccueilTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesAccueilTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesAccueilTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesAccueilTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> enfantId = const Value.absent(),
                Value<int> accueillantId = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => PreferencesAccueilCompanion(
                id: id,
                enfantId: enfantId,
                accueillantId: accueillantId,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int enfantId,
                required int accueillantId,
                required String type,
              }) => PreferencesAccueilCompanion.insert(
                id: id,
                enfantId: enfantId,
                accueillantId: accueillantId,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PreferencesAccueilTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({enfantId = false, accueillantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (enfantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.enfantId,
                                referencedTable:
                                    $$PreferencesAccueilTableReferences
                                        ._enfantIdTable(db),
                                referencedColumn:
                                    $$PreferencesAccueilTableReferences
                                        ._enfantIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (accueillantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accueillantId,
                                referencedTable:
                                    $$PreferencesAccueilTableReferences
                                        ._accueillantIdTable(db),
                                referencedColumn:
                                    $$PreferencesAccueilTableReferences
                                        ._accueillantIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PreferencesAccueilTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesAccueilTable,
      PreferenceAccueil,
      $$PreferencesAccueilTableFilterComposer,
      $$PreferencesAccueilTableOrderingComposer,
      $$PreferencesAccueilTableAnnotationComposer,
      $$PreferencesAccueilTableCreateCompanionBuilder,
      $$PreferencesAccueilTableUpdateCompanionBuilder,
      (PreferenceAccueil, $$PreferencesAccueilTableReferences),
      PreferenceAccueil,
      PrefetchHooks Function({bool enfantId, bool accueillantId})
    >;
typedef $$SolutionsAlternativesTableCreateCompanionBuilder =
    SolutionsAlternativesCompanion Function({
      Value<int> id,
      required int enfantId,
      required DateTime debut,
      required DateTime fin,
      required String type,
      Value<String?> details,
    });
typedef $$SolutionsAlternativesTableUpdateCompanionBuilder =
    SolutionsAlternativesCompanion Function({
      Value<int> id,
      Value<int> enfantId,
      Value<DateTime> debut,
      Value<DateTime> fin,
      Value<String> type,
      Value<String?> details,
    });

final class $$SolutionsAlternativesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SolutionsAlternativesTable,
          SolutionAlternative
        > {
  $$SolutionsAlternativesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnfantsTable _enfantIdTable(_$AppDatabase db) =>
      db.enfants.createAlias('solutions_alternatives__enfant_id__enfants__id');

  $$EnfantsTableProcessedTableManager get enfantId {
    final $_column = $_itemColumn<int>('enfant_id')!;

    final manager = $$EnfantsTableTableManager(
      $_db,
      $_db.enfants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enfantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SolutionsAlternativesTableFilterComposer
    extends Composer<_$AppDatabase, $SolutionsAlternativesTable> {
  $$SolutionsAlternativesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  $$EnfantsTableFilterComposer get enfantId {
    final $$EnfantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableFilterComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SolutionsAlternativesTableOrderingComposer
    extends Composer<_$AppDatabase, $SolutionsAlternativesTable> {
  $$SolutionsAlternativesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get debut => $composableBuilder(
    column: $table.debut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fin => $composableBuilder(
    column: $table.fin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnfantsTableOrderingComposer get enfantId {
    final $$EnfantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableOrderingComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SolutionsAlternativesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SolutionsAlternativesTable> {
  $$SolutionsAlternativesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get debut =>
      $composableBuilder(column: $table.debut, builder: (column) => column);

  GeneratedColumn<DateTime> get fin =>
      $composableBuilder(column: $table.fin, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  $$EnfantsTableAnnotationComposer get enfantId {
    final $$EnfantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enfantId,
      referencedTable: $db.enfants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnfantsTableAnnotationComposer(
            $db: $db,
            $table: $db.enfants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SolutionsAlternativesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SolutionsAlternativesTable,
          SolutionAlternative,
          $$SolutionsAlternativesTableFilterComposer,
          $$SolutionsAlternativesTableOrderingComposer,
          $$SolutionsAlternativesTableAnnotationComposer,
          $$SolutionsAlternativesTableCreateCompanionBuilder,
          $$SolutionsAlternativesTableUpdateCompanionBuilder,
          (SolutionAlternative, $$SolutionsAlternativesTableReferences),
          SolutionAlternative,
          PrefetchHooks Function({bool enfantId})
        > {
  $$SolutionsAlternativesTableTableManager(
    _$AppDatabase db,
    $SolutionsAlternativesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SolutionsAlternativesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SolutionsAlternativesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SolutionsAlternativesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> enfantId = const Value.absent(),
                Value<DateTime> debut = const Value.absent(),
                Value<DateTime> fin = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> details = const Value.absent(),
              }) => SolutionsAlternativesCompanion(
                id: id,
                enfantId: enfantId,
                debut: debut,
                fin: fin,
                type: type,
                details: details,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int enfantId,
                required DateTime debut,
                required DateTime fin,
                required String type,
                Value<String?> details = const Value.absent(),
              }) => SolutionsAlternativesCompanion.insert(
                id: id,
                enfantId: enfantId,
                debut: debut,
                fin: fin,
                type: type,
                details: details,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SolutionsAlternativesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({enfantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (enfantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.enfantId,
                                referencedTable:
                                    $$SolutionsAlternativesTableReferences
                                        ._enfantIdTable(db),
                                referencedColumn:
                                    $$SolutionsAlternativesTableReferences
                                        ._enfantIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SolutionsAlternativesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SolutionsAlternativesTable,
      SolutionAlternative,
      $$SolutionsAlternativesTableFilterComposer,
      $$SolutionsAlternativesTableOrderingComposer,
      $$SolutionsAlternativesTableAnnotationComposer,
      $$SolutionsAlternativesTableCreateCompanionBuilder,
      $$SolutionsAlternativesTableUpdateCompanionBuilder,
      (SolutionAlternative, $$SolutionsAlternativesTableReferences),
      SolutionAlternative,
      PrefetchHooks Function({bool enfantId})
    >;
typedef $$ReglagesTableCreateCompanionBuilder =
    ReglagesCompanion Function({
      required String cle,
      Value<String> valeur,
      Value<int> rowid,
    });
typedef $$ReglagesTableUpdateCompanionBuilder =
    ReglagesCompanion Function({
      Value<String> cle,
      Value<String> valeur,
      Value<int> rowid,
    });

class $$ReglagesTableFilterComposer
    extends Composer<_$AppDatabase, $ReglagesTable> {
  $$ReglagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReglagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReglagesTable> {
  $$ReglagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReglagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReglagesTable> {
  $$ReglagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cle =>
      $composableBuilder(column: $table.cle, builder: (column) => column);

  GeneratedColumn<String> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);
}

class $$ReglagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReglagesTable,
          Reglage,
          $$ReglagesTableFilterComposer,
          $$ReglagesTableOrderingComposer,
          $$ReglagesTableAnnotationComposer,
          $$ReglagesTableCreateCompanionBuilder,
          $$ReglagesTableUpdateCompanionBuilder,
          (Reglage, BaseReferences<_$AppDatabase, $ReglagesTable, Reglage>),
          Reglage,
          PrefetchHooks Function()
        > {
  $$ReglagesTableTableManager(_$AppDatabase db, $ReglagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReglagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReglagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReglagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cle = const Value.absent(),
                Value<String> valeur = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReglagesCompanion(cle: cle, valeur: valeur, rowid: rowid),
          createCompanionCallback:
              ({
                required String cle,
                Value<String> valeur = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReglagesCompanion.insert(
                cle: cle,
                valeur: valeur,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReglagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReglagesTable,
      Reglage,
      $$ReglagesTableFilterComposer,
      $$ReglagesTableOrderingComposer,
      $$ReglagesTableAnnotationComposer,
      $$ReglagesTableCreateCompanionBuilder,
      $$ReglagesTableUpdateCompanionBuilder,
      (Reglage, BaseReferences<_$AppDatabase, $ReglagesTable, Reglage>),
      Reglage,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccueillantsTableTableManager get accueillants =>
      $$AccueillantsTableTableManager(_db, _db.accueillants);
  $$FratriesTableTableManager get fratries =>
      $$FratriesTableTableManager(_db, _db.fratries);
  $$EnfantsTableTableManager get enfants =>
      $$EnfantsTableTableManager(_db, _db.enfants);
  $$DisponibilitesAccueilTableTableManager get disponibilitesAccueil =>
      $$DisponibilitesAccueilTableTableManager(_db, _db.disponibilitesAccueil);
  $$IndisponibilitesTableTableManager get indisponibilites =>
      $$IndisponibilitesTableTableManager(_db, _db.indisponibilites);
  $$BesoinsRelaisTableTableManager get besoinsRelais =>
      $$BesoinsRelaisTableTableManager(_db, _db.besoinsRelais);
  $$AffectationsTableTableManager get affectations =>
      $$AffectationsTableTableManager(_db, _db.affectations);
  $$IncompatibilitesTableTableManager get incompatibilites =>
      $$IncompatibilitesTableTableManager(_db, _db.incompatibilites);
  $$PreferencesAccueilTableTableManager get preferencesAccueil =>
      $$PreferencesAccueilTableTableManager(_db, _db.preferencesAccueil);
  $$SolutionsAlternativesTableTableManager get solutionsAlternatives =>
      $$SolutionsAlternativesTableTableManager(_db, _db.solutionsAlternatives);
  $$ReglagesTableTableManager get reglages =>
      $$ReglagesTableTableManager(_db, _db.reglages);
}
