// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whatsappNumberMeta = const VerificationMeta(
    'whatsappNumber',
  );
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
    'whatsapp_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    phoneNumber,
    whatsappNumber,
    email,
    address,
    city,
    notes,
    createdAt,
    updatedAt,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
        _whatsappNumberMeta,
        whatsappNumber.isAcceptableOrUnknown(
          data['whatsapp_number']!,
          _whatsappNumberMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      whatsappNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_number'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? whatsappNumber;
  final String? email;
  final String? address;
  final String? city;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  const CustomerRow({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.whatsappNumber,
    this.email,
    this.address,
    this.city,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['phone_number'] = Variable<String>(phoneNumber);
    if (!nullToAbsent || whatsappNumber != null) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      phoneNumber: Value(phoneNumber),
      whatsappNumber: whatsappNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappNumber),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory CustomerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      whatsappNumber: serializer.fromJson<String?>(json['whatsappNumber']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'whatsappNumber': serializer.toJson<String?>(whatsappNumber),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  CustomerRow copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    Value<String?> whatsappNumber = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) => CustomerRow(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    whatsappNumber: whatsappNumber.present
        ? whatsappNumber.value
        : this.whatsappNumber,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    city: city.present ? city.value : this.city,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
  );
  CustomerRow copyWithCompanion(CustomersCompanion data) {
    return CustomerRow(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    phoneNumber,
    whatsappNumber,
    email,
    address,
    city,
    notes,
    createdAt,
    updatedAt,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.phoneNumber == this.phoneNumber &&
          other.whatsappNumber == this.whatsappNumber &&
          other.email == this.email &&
          other.address == this.address &&
          other.city == this.city &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class CustomersCompanion extends UpdateCompanion<CustomerRow> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> phoneNumber;
  final Value<String?> whatsappNumber;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String fullName,
    required String phoneNumber,
    this.whatsappNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       phoneNumber = Value(phoneNumber),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CustomerRow> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? phoneNumber,
    Expression<String>? whatsappNumber,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String>? phoneNumber,
    Value<String?>? whatsappNumber,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? city,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles
    with TableInfo<$VehiclesTable, VehicleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>(
        'registration_number',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _vinNumberMeta = const VerificationMeta(
    'vinNumber',
  );
  @override
  late final GeneratedColumn<String> vinNumber = GeneratedColumn<String>(
    'vin_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engineNumberMeta = const VerificationMeta(
    'engineNumber',
  );
  @override
  late final GeneratedColumn<String> engineNumber = GeneratedColumn<String>(
    'engine_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engineCapacityMeta = const VerificationMeta(
    'engineCapacity',
  );
  @override
  late final GeneratedColumn<String> engineCapacity = GeneratedColumn<String>(
    'engine_capacity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transmissionMeta = const VerificationMeta(
    'transmission',
  );
  @override
  late final GeneratedColumn<String> transmission = GeneratedColumn<String>(
    'transmission',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentOdoMeta = const VerificationMeta(
    'currentOdo',
  );
  @override
  late final GeneratedColumn<int> currentOdo = GeneratedColumn<int>(
    'current_odo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insuranceExpiryMeta = const VerificationMeta(
    'insuranceExpiry',
  );
  @override
  late final GeneratedColumn<DateTime> insuranceExpiry =
      GeneratedColumn<DateTime>(
        'insurance_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _registrationExpiryMeta =
      const VerificationMeta('registrationExpiry');
  @override
  late final GeneratedColumn<DateTime> registrationExpiry =
      GeneratedColumn<DateTime>(
        'registration_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    make,
    model,
    variant,
    year,
    registrationNumber,
    vinNumber,
    engineNumber,
    engineCapacity,
    fuelType,
    transmission,
    color,
    currentOdo,
    purchaseDate,
    insuranceExpiry,
    registrationExpiry,
    imagePath,
    notes,
    createdAt,
    updatedAt,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    } else if (isInserting) {
      context.missing(_makeMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('registration_number')) {
      context.handle(
        _registrationNumberMeta,
        registrationNumber.isAcceptableOrUnknown(
          data['registration_number']!,
          _registrationNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registrationNumberMeta);
    }
    if (data.containsKey('vin_number')) {
      context.handle(
        _vinNumberMeta,
        vinNumber.isAcceptableOrUnknown(data['vin_number']!, _vinNumberMeta),
      );
    }
    if (data.containsKey('engine_number')) {
      context.handle(
        _engineNumberMeta,
        engineNumber.isAcceptableOrUnknown(
          data['engine_number']!,
          _engineNumberMeta,
        ),
      );
    }
    if (data.containsKey('engine_capacity')) {
      context.handle(
        _engineCapacityMeta,
        engineCapacity.isAcceptableOrUnknown(
          data['engine_capacity']!,
          _engineCapacityMeta,
        ),
      );
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('transmission')) {
      context.handle(
        _transmissionMeta,
        transmission.isAcceptableOrUnknown(
          data['transmission']!,
          _transmissionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transmissionMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('current_odo')) {
      context.handle(
        _currentOdoMeta,
        currentOdo.isAcceptableOrUnknown(data['current_odo']!, _currentOdoMeta),
      );
    } else if (isInserting) {
      context.missing(_currentOdoMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('insurance_expiry')) {
      context.handle(
        _insuranceExpiryMeta,
        insuranceExpiry.isAcceptableOrUnknown(
          data['insurance_expiry']!,
          _insuranceExpiryMeta,
        ),
      );
    }
    if (data.containsKey('registration_expiry')) {
      context.handle(
        _registrationExpiryMeta,
        registrationExpiry.isAcceptableOrUnknown(
          data['registration_expiry']!,
          _registrationExpiryMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      registrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration_number'],
      )!,
      vinNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vin_number'],
      ),
      engineNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_number'],
      ),
      engineCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_capacity'],
      ),
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      transmission: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transmission'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      currentOdo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_odo'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      insuranceExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}insurance_expiry'],
      ),
      registrationExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_expiry'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class VehicleRow extends DataClass implements Insertable<VehicleRow> {
  final String id;
  final String customerId;
  final String make;
  final String model;
  final String? variant;
  final int? year;
  final String registrationNumber;
  final String? vinNumber;
  final String? engineNumber;
  final String? engineCapacity;

  /// petrol | diesel | hybrid | electric
  final String fuelType;

  /// automatic | manual | cvt
  final String transmission;
  final String? color;
  final int currentOdo;
  final DateTime? purchaseDate;
  final DateTime? insuranceExpiry;
  final DateTime? registrationExpiry;
  final String? imagePath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  const VehicleRow({
    required this.id,
    required this.customerId,
    required this.make,
    required this.model,
    this.variant,
    this.year,
    required this.registrationNumber,
    this.vinNumber,
    this.engineNumber,
    this.engineCapacity,
    required this.fuelType,
    required this.transmission,
    this.color,
    required this.currentOdo,
    this.purchaseDate,
    this.insuranceExpiry,
    this.registrationExpiry,
    this.imagePath,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['make'] = Variable<String>(make);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || variant != null) {
      map['variant'] = Variable<String>(variant);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['registration_number'] = Variable<String>(registrationNumber);
    if (!nullToAbsent || vinNumber != null) {
      map['vin_number'] = Variable<String>(vinNumber);
    }
    if (!nullToAbsent || engineNumber != null) {
      map['engine_number'] = Variable<String>(engineNumber);
    }
    if (!nullToAbsent || engineCapacity != null) {
      map['engine_capacity'] = Variable<String>(engineCapacity);
    }
    map['fuel_type'] = Variable<String>(fuelType);
    map['transmission'] = Variable<String>(transmission);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['current_odo'] = Variable<int>(currentOdo);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || insuranceExpiry != null) {
      map['insurance_expiry'] = Variable<DateTime>(insuranceExpiry);
    }
    if (!nullToAbsent || registrationExpiry != null) {
      map['registration_expiry'] = Variable<DateTime>(registrationExpiry);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      customerId: Value(customerId),
      make: Value(make),
      model: Value(model),
      variant: variant == null && nullToAbsent
          ? const Value.absent()
          : Value(variant),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      registrationNumber: Value(registrationNumber),
      vinNumber: vinNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(vinNumber),
      engineNumber: engineNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(engineNumber),
      engineCapacity: engineCapacity == null && nullToAbsent
          ? const Value.absent()
          : Value(engineCapacity),
      fuelType: Value(fuelType),
      transmission: Value(transmission),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      currentOdo: Value(currentOdo),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      insuranceExpiry: insuranceExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceExpiry),
      registrationExpiry: registrationExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationExpiry),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory VehicleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleRow(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      make: serializer.fromJson<String>(json['make']),
      model: serializer.fromJson<String>(json['model']),
      variant: serializer.fromJson<String?>(json['variant']),
      year: serializer.fromJson<int?>(json['year']),
      registrationNumber: serializer.fromJson<String>(
        json['registrationNumber'],
      ),
      vinNumber: serializer.fromJson<String?>(json['vinNumber']),
      engineNumber: serializer.fromJson<String?>(json['engineNumber']),
      engineCapacity: serializer.fromJson<String?>(json['engineCapacity']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      transmission: serializer.fromJson<String>(json['transmission']),
      color: serializer.fromJson<String?>(json['color']),
      currentOdo: serializer.fromJson<int>(json['currentOdo']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      insuranceExpiry: serializer.fromJson<DateTime?>(json['insuranceExpiry']),
      registrationExpiry: serializer.fromJson<DateTime?>(
        json['registrationExpiry'],
      ),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'make': serializer.toJson<String>(make),
      'model': serializer.toJson<String>(model),
      'variant': serializer.toJson<String?>(variant),
      'year': serializer.toJson<int?>(year),
      'registrationNumber': serializer.toJson<String>(registrationNumber),
      'vinNumber': serializer.toJson<String?>(vinNumber),
      'engineNumber': serializer.toJson<String?>(engineNumber),
      'engineCapacity': serializer.toJson<String?>(engineCapacity),
      'fuelType': serializer.toJson<String>(fuelType),
      'transmission': serializer.toJson<String>(transmission),
      'color': serializer.toJson<String?>(color),
      'currentOdo': serializer.toJson<int>(currentOdo),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'insuranceExpiry': serializer.toJson<DateTime?>(insuranceExpiry),
      'registrationExpiry': serializer.toJson<DateTime?>(registrationExpiry),
      'imagePath': serializer.toJson<String?>(imagePath),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  VehicleRow copyWith({
    String? id,
    String? customerId,
    String? make,
    String? model,
    Value<String?> variant = const Value.absent(),
    Value<int?> year = const Value.absent(),
    String? registrationNumber,
    Value<String?> vinNumber = const Value.absent(),
    Value<String?> engineNumber = const Value.absent(),
    Value<String?> engineCapacity = const Value.absent(),
    String? fuelType,
    String? transmission,
    Value<String?> color = const Value.absent(),
    int? currentOdo,
    Value<DateTime?> purchaseDate = const Value.absent(),
    Value<DateTime?> insuranceExpiry = const Value.absent(),
    Value<DateTime?> registrationExpiry = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) => VehicleRow(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    make: make ?? this.make,
    model: model ?? this.model,
    variant: variant.present ? variant.value : this.variant,
    year: year.present ? year.value : this.year,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    vinNumber: vinNumber.present ? vinNumber.value : this.vinNumber,
    engineNumber: engineNumber.present ? engineNumber.value : this.engineNumber,
    engineCapacity: engineCapacity.present
        ? engineCapacity.value
        : this.engineCapacity,
    fuelType: fuelType ?? this.fuelType,
    transmission: transmission ?? this.transmission,
    color: color.present ? color.value : this.color,
    currentOdo: currentOdo ?? this.currentOdo,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    insuranceExpiry: insuranceExpiry.present
        ? insuranceExpiry.value
        : this.insuranceExpiry,
    registrationExpiry: registrationExpiry.present
        ? registrationExpiry.value
        : this.registrationExpiry,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
  );
  VehicleRow copyWithCompanion(VehiclesCompanion data) {
    return VehicleRow(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      variant: data.variant.present ? data.variant.value : this.variant,
      year: data.year.present ? data.year.value : this.year,
      registrationNumber: data.registrationNumber.present
          ? data.registrationNumber.value
          : this.registrationNumber,
      vinNumber: data.vinNumber.present ? data.vinNumber.value : this.vinNumber,
      engineNumber: data.engineNumber.present
          ? data.engineNumber.value
          : this.engineNumber,
      engineCapacity: data.engineCapacity.present
          ? data.engineCapacity.value
          : this.engineCapacity,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      transmission: data.transmission.present
          ? data.transmission.value
          : this.transmission,
      color: data.color.present ? data.color.value : this.color,
      currentOdo: data.currentOdo.present
          ? data.currentOdo.value
          : this.currentOdo,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      insuranceExpiry: data.insuranceExpiry.present
          ? data.insuranceExpiry.value
          : this.insuranceExpiry,
      registrationExpiry: data.registrationExpiry.present
          ? data.registrationExpiry.value
          : this.registrationExpiry,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleRow(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('variant: $variant, ')
          ..write('year: $year, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('vinNumber: $vinNumber, ')
          ..write('engineNumber: $engineNumber, ')
          ..write('engineCapacity: $engineCapacity, ')
          ..write('fuelType: $fuelType, ')
          ..write('transmission: $transmission, ')
          ..write('color: $color, ')
          ..write('currentOdo: $currentOdo, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('insuranceExpiry: $insuranceExpiry, ')
          ..write('registrationExpiry: $registrationExpiry, ')
          ..write('imagePath: $imagePath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    customerId,
    make,
    model,
    variant,
    year,
    registrationNumber,
    vinNumber,
    engineNumber,
    engineCapacity,
    fuelType,
    transmission,
    color,
    currentOdo,
    purchaseDate,
    insuranceExpiry,
    registrationExpiry,
    imagePath,
    notes,
    createdAt,
    updatedAt,
    isArchived,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleRow &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.make == this.make &&
          other.model == this.model &&
          other.variant == this.variant &&
          other.year == this.year &&
          other.registrationNumber == this.registrationNumber &&
          other.vinNumber == this.vinNumber &&
          other.engineNumber == this.engineNumber &&
          other.engineCapacity == this.engineCapacity &&
          other.fuelType == this.fuelType &&
          other.transmission == this.transmission &&
          other.color == this.color &&
          other.currentOdo == this.currentOdo &&
          other.purchaseDate == this.purchaseDate &&
          other.insuranceExpiry == this.insuranceExpiry &&
          other.registrationExpiry == this.registrationExpiry &&
          other.imagePath == this.imagePath &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class VehiclesCompanion extends UpdateCompanion<VehicleRow> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> make;
  final Value<String> model;
  final Value<String?> variant;
  final Value<int?> year;
  final Value<String> registrationNumber;
  final Value<String?> vinNumber;
  final Value<String?> engineNumber;
  final Value<String?> engineCapacity;
  final Value<String> fuelType;
  final Value<String> transmission;
  final Value<String?> color;
  final Value<int> currentOdo;
  final Value<DateTime?> purchaseDate;
  final Value<DateTime?> insuranceExpiry;
  final Value<DateTime?> registrationExpiry;
  final Value<String?> imagePath;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.variant = const Value.absent(),
    this.year = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.vinNumber = const Value.absent(),
    this.engineNumber = const Value.absent(),
    this.engineCapacity = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.transmission = const Value.absent(),
    this.color = const Value.absent(),
    this.currentOdo = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.insuranceExpiry = const Value.absent(),
    this.registrationExpiry = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required String customerId,
    required String make,
    required String model,
    this.variant = const Value.absent(),
    this.year = const Value.absent(),
    required String registrationNumber,
    this.vinNumber = const Value.absent(),
    this.engineNumber = const Value.absent(),
    this.engineCapacity = const Value.absent(),
    required String fuelType,
    required String transmission,
    this.color = const Value.absent(),
    required int currentOdo,
    this.purchaseDate = const Value.absent(),
    this.insuranceExpiry = const Value.absent(),
    this.registrationExpiry = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       make = Value(make),
       model = Value(model),
       registrationNumber = Value(registrationNumber),
       fuelType = Value(fuelType),
       transmission = Value(transmission),
       currentOdo = Value(currentOdo),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VehicleRow> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? make,
    Expression<String>? model,
    Expression<String>? variant,
    Expression<int>? year,
    Expression<String>? registrationNumber,
    Expression<String>? vinNumber,
    Expression<String>? engineNumber,
    Expression<String>? engineCapacity,
    Expression<String>? fuelType,
    Expression<String>? transmission,
    Expression<String>? color,
    Expression<int>? currentOdo,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? insuranceExpiry,
    Expression<DateTime>? registrationExpiry,
    Expression<String>? imagePath,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (variant != null) 'variant': variant,
      if (year != null) 'year': year,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (vinNumber != null) 'vin_number': vinNumber,
      if (engineNumber != null) 'engine_number': engineNumber,
      if (engineCapacity != null) 'engine_capacity': engineCapacity,
      if (fuelType != null) 'fuel_type': fuelType,
      if (transmission != null) 'transmission': transmission,
      if (color != null) 'color': color,
      if (currentOdo != null) 'current_odo': currentOdo,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (insuranceExpiry != null) 'insurance_expiry': insuranceExpiry,
      if (registrationExpiry != null) 'registration_expiry': registrationExpiry,
      if (imagePath != null) 'image_path': imagePath,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? make,
    Value<String>? model,
    Value<String?>? variant,
    Value<int?>? year,
    Value<String>? registrationNumber,
    Value<String?>? vinNumber,
    Value<String?>? engineNumber,
    Value<String?>? engineCapacity,
    Value<String>? fuelType,
    Value<String>? transmission,
    Value<String?>? color,
    Value<int>? currentOdo,
    Value<DateTime?>? purchaseDate,
    Value<DateTime?>? insuranceExpiry,
    Value<DateTime?>? registrationExpiry,
    Value<String?>? imagePath,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      make: make ?? this.make,
      model: model ?? this.model,
      variant: variant ?? this.variant,
      year: year ?? this.year,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vinNumber: vinNumber ?? this.vinNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      engineCapacity: engineCapacity ?? this.engineCapacity,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      color: color ?? this.color,
      currentOdo: currentOdo ?? this.currentOdo,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      registrationExpiry: registrationExpiry ?? this.registrationExpiry,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String>(registrationNumber.value);
    }
    if (vinNumber.present) {
      map['vin_number'] = Variable<String>(vinNumber.value);
    }
    if (engineNumber.present) {
      map['engine_number'] = Variable<String>(engineNumber.value);
    }
    if (engineCapacity.present) {
      map['engine_capacity'] = Variable<String>(engineCapacity.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (transmission.present) {
      map['transmission'] = Variable<String>(transmission.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (currentOdo.present) {
      map['current_odo'] = Variable<int>(currentOdo.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (insuranceExpiry.present) {
      map['insurance_expiry'] = Variable<DateTime>(insuranceExpiry.value);
    }
    if (registrationExpiry.present) {
      map['registration_expiry'] = Variable<DateTime>(registrationExpiry.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('variant: $variant, ')
          ..write('year: $year, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('vinNumber: $vinNumber, ')
          ..write('engineNumber: $engineNumber, ')
          ..write('engineCapacity: $engineCapacity, ')
          ..write('fuelType: $fuelType, ')
          ..write('transmission: $transmission, ')
          ..write('color: $color, ')
          ..write('currentOdo: $currentOdo, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('insuranceExpiry: $insuranceExpiry, ')
          ..write('registrationExpiry: $registrationExpiry, ')
          ..write('imagePath: $imagePath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceRecordsTable extends ServiceRecords
    with TableInfo<$ServiceRecordsTable, ServiceRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _serviceDateMeta = const VerificationMeta(
    'serviceDate',
  );
  @override
  late final GeneratedColumn<DateTime> serviceDate = GeneratedColumn<DateTime>(
    'service_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerReadingMeta = const VerificationMeta(
    'odometerReading',
  );
  @override
  late final GeneratedColumn<int> odometerReading = GeneratedColumn<int>(
    'odometer_reading',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oilBrandMeta = const VerificationMeta(
    'oilBrand',
  );
  @override
  late final GeneratedColumn<String> oilBrand = GeneratedColumn<String>(
    'oil_brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _laborCostMeta = const VerificationMeta(
    'laborCost',
  );
  @override
  late final GeneratedColumn<double> laborCost = GeneratedColumn<double>(
    'labor_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _partsCostMeta = const VerificationMeta(
    'partsCost',
  );
  @override
  late final GeneratedColumn<double> partsCost = GeneratedColumn<double>(
    'parts_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
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
  static const VerificationMeta _reminderTypeMeta = const VerificationMeta(
    'reminderType',
  );
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
    'reminder_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextServiceOdometerMeta =
      const VerificationMeta('nextServiceOdometer');
  @override
  late final GeneratedColumn<int> nextServiceOdometer = GeneratedColumn<int>(
    'next_service_odometer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextServiceDateMeta = const VerificationMeta(
    'nextServiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextServiceDate =
      GeneratedColumn<DateTime>(
        'next_service_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _whatsappEnabledMeta = const VerificationMeta(
    'whatsappEnabled',
  );
  @override
  late final GeneratedColumn<bool> whatsappEnabled = GeneratedColumn<bool>(
    'whatsapp_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("whatsapp_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    serviceDate,
    odometerReading,
    serviceType,
    description,
    oilBrand,
    laborCost,
    partsCost,
    totalCost,
    notes,
    reminderType,
    nextServiceOdometer,
    nextServiceDate,
    reminderEnabled,
    whatsappEnabled,
    createdAt,
    updatedAt,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('service_date')) {
      context.handle(
        _serviceDateMeta,
        serviceDate.isAcceptableOrUnknown(
          data['service_date']!,
          _serviceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceDateMeta);
    }
    if (data.containsKey('odometer_reading')) {
      context.handle(
        _odometerReadingMeta,
        odometerReading.isAcceptableOrUnknown(
          data['odometer_reading']!,
          _odometerReadingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_odometerReadingMeta);
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('oil_brand')) {
      context.handle(
        _oilBrandMeta,
        oilBrand.isAcceptableOrUnknown(data['oil_brand']!, _oilBrandMeta),
      );
    }
    if (data.containsKey('labor_cost')) {
      context.handle(
        _laborCostMeta,
        laborCost.isAcceptableOrUnknown(data['labor_cost']!, _laborCostMeta),
      );
    }
    if (data.containsKey('parts_cost')) {
      context.handle(
        _partsCostMeta,
        partsCost.isAcceptableOrUnknown(data['parts_cost']!, _partsCostMeta),
      );
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
        _reminderTypeMeta,
        reminderType.isAcceptableOrUnknown(
          data['reminder_type']!,
          _reminderTypeMeta,
        ),
      );
    }
    if (data.containsKey('next_service_odometer')) {
      context.handle(
        _nextServiceOdometerMeta,
        nextServiceOdometer.isAcceptableOrUnknown(
          data['next_service_odometer']!,
          _nextServiceOdometerMeta,
        ),
      );
    }
    if (data.containsKey('next_service_date')) {
      context.handle(
        _nextServiceDateMeta,
        nextServiceDate.isAcceptableOrUnknown(
          data['next_service_date']!,
          _nextServiceDateMeta,
        ),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_enabled')) {
      context.handle(
        _whatsappEnabledMeta,
        whatsappEnabled.isAcceptableOrUnknown(
          data['whatsapp_enabled']!,
          _whatsappEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      serviceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}service_date'],
      )!,
      odometerReading: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometer_reading'],
      )!,
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      oilBrand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oil_brand'],
      ),
      laborCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}labor_cost'],
      )!,
      partsCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}parts_cost'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      reminderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_type'],
      ),
      nextServiceOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_service_odometer'],
      ),
      nextServiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_service_date'],
      ),
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      whatsappEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}whatsapp_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $ServiceRecordsTable createAlias(String alias) {
    return $ServiceRecordsTable(attachedDatabase, alias);
  }
}

class ServiceRecordRow extends DataClass
    implements Insertable<ServiceRecordRow> {
  final String id;
  final String vehicleId;
  final DateTime serviceDate;
  final int odometerReading;
  final String serviceType;
  final String? description;
  final String? oilBrand;
  final double laborCost;
  final double partsCost;
  final double totalCost;
  final String? notes;

  /// km | date | both — used when creating/updating the linked reminder.
  final String? reminderType;
  final int? nextServiceOdometer;
  final DateTime? nextServiceDate;
  final bool reminderEnabled;
  final bool whatsappEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  const ServiceRecordRow({
    required this.id,
    required this.vehicleId,
    required this.serviceDate,
    required this.odometerReading,
    required this.serviceType,
    this.description,
    this.oilBrand,
    required this.laborCost,
    required this.partsCost,
    required this.totalCost,
    this.notes,
    this.reminderType,
    this.nextServiceOdometer,
    this.nextServiceDate,
    required this.reminderEnabled,
    required this.whatsappEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['service_date'] = Variable<DateTime>(serviceDate);
    map['odometer_reading'] = Variable<int>(odometerReading);
    map['service_type'] = Variable<String>(serviceType);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || oilBrand != null) {
      map['oil_brand'] = Variable<String>(oilBrand);
    }
    map['labor_cost'] = Variable<double>(laborCost);
    map['parts_cost'] = Variable<double>(partsCost);
    map['total_cost'] = Variable<double>(totalCost);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || reminderType != null) {
      map['reminder_type'] = Variable<String>(reminderType);
    }
    if (!nullToAbsent || nextServiceOdometer != null) {
      map['next_service_odometer'] = Variable<int>(nextServiceOdometer);
    }
    if (!nullToAbsent || nextServiceDate != null) {
      map['next_service_date'] = Variable<DateTime>(nextServiceDate);
    }
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['whatsapp_enabled'] = Variable<bool>(whatsappEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  ServiceRecordsCompanion toCompanion(bool nullToAbsent) {
    return ServiceRecordsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      serviceDate: Value(serviceDate),
      odometerReading: Value(odometerReading),
      serviceType: Value(serviceType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      oilBrand: oilBrand == null && nullToAbsent
          ? const Value.absent()
          : Value(oilBrand),
      laborCost: Value(laborCost),
      partsCost: Value(partsCost),
      totalCost: Value(totalCost),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      reminderType: reminderType == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderType),
      nextServiceOdometer: nextServiceOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceOdometer),
      nextServiceDate: nextServiceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceDate),
      reminderEnabled: Value(reminderEnabled),
      whatsappEnabled: Value(whatsappEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory ServiceRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceRecordRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      serviceDate: serializer.fromJson<DateTime>(json['serviceDate']),
      odometerReading: serializer.fromJson<int>(json['odometerReading']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      description: serializer.fromJson<String?>(json['description']),
      oilBrand: serializer.fromJson<String?>(json['oilBrand']),
      laborCost: serializer.fromJson<double>(json['laborCost']),
      partsCost: serializer.fromJson<double>(json['partsCost']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      notes: serializer.fromJson<String?>(json['notes']),
      reminderType: serializer.fromJson<String?>(json['reminderType']),
      nextServiceOdometer: serializer.fromJson<int?>(
        json['nextServiceOdometer'],
      ),
      nextServiceDate: serializer.fromJson<DateTime?>(json['nextServiceDate']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      whatsappEnabled: serializer.fromJson<bool>(json['whatsappEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'serviceDate': serializer.toJson<DateTime>(serviceDate),
      'odometerReading': serializer.toJson<int>(odometerReading),
      'serviceType': serializer.toJson<String>(serviceType),
      'description': serializer.toJson<String?>(description),
      'oilBrand': serializer.toJson<String?>(oilBrand),
      'laborCost': serializer.toJson<double>(laborCost),
      'partsCost': serializer.toJson<double>(partsCost),
      'totalCost': serializer.toJson<double>(totalCost),
      'notes': serializer.toJson<String?>(notes),
      'reminderType': serializer.toJson<String?>(reminderType),
      'nextServiceOdometer': serializer.toJson<int?>(nextServiceOdometer),
      'nextServiceDate': serializer.toJson<DateTime?>(nextServiceDate),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'whatsappEnabled': serializer.toJson<bool>(whatsappEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  ServiceRecordRow copyWith({
    String? id,
    String? vehicleId,
    DateTime? serviceDate,
    int? odometerReading,
    String? serviceType,
    Value<String?> description = const Value.absent(),
    Value<String?> oilBrand = const Value.absent(),
    double? laborCost,
    double? partsCost,
    double? totalCost,
    Value<String?> notes = const Value.absent(),
    Value<String?> reminderType = const Value.absent(),
    Value<int?> nextServiceOdometer = const Value.absent(),
    Value<DateTime?> nextServiceDate = const Value.absent(),
    bool? reminderEnabled,
    bool? whatsappEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) => ServiceRecordRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    serviceDate: serviceDate ?? this.serviceDate,
    odometerReading: odometerReading ?? this.odometerReading,
    serviceType: serviceType ?? this.serviceType,
    description: description.present ? description.value : this.description,
    oilBrand: oilBrand.present ? oilBrand.value : this.oilBrand,
    laborCost: laborCost ?? this.laborCost,
    partsCost: partsCost ?? this.partsCost,
    totalCost: totalCost ?? this.totalCost,
    notes: notes.present ? notes.value : this.notes,
    reminderType: reminderType.present ? reminderType.value : this.reminderType,
    nextServiceOdometer: nextServiceOdometer.present
        ? nextServiceOdometer.value
        : this.nextServiceOdometer,
    nextServiceDate: nextServiceDate.present
        ? nextServiceDate.value
        : this.nextServiceDate,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
  );
  ServiceRecordRow copyWithCompanion(ServiceRecordsCompanion data) {
    return ServiceRecordRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      serviceDate: data.serviceDate.present
          ? data.serviceDate.value
          : this.serviceDate,
      odometerReading: data.odometerReading.present
          ? data.odometerReading.value
          : this.odometerReading,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      description: data.description.present
          ? data.description.value
          : this.description,
      oilBrand: data.oilBrand.present ? data.oilBrand.value : this.oilBrand,
      laborCost: data.laborCost.present ? data.laborCost.value : this.laborCost,
      partsCost: data.partsCost.present ? data.partsCost.value : this.partsCost,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      notes: data.notes.present ? data.notes.value : this.notes,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      nextServiceOdometer: data.nextServiceOdometer.present
          ? data.nextServiceOdometer.value
          : this.nextServiceOdometer,
      nextServiceDate: data.nextServiceDate.present
          ? data.nextServiceDate.value
          : this.nextServiceDate,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      whatsappEnabled: data.whatsappEnabled.present
          ? data.whatsappEnabled.value
          : this.whatsappEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('serviceDate: $serviceDate, ')
          ..write('odometerReading: $odometerReading, ')
          ..write('serviceType: $serviceType, ')
          ..write('description: $description, ')
          ..write('oilBrand: $oilBrand, ')
          ..write('laborCost: $laborCost, ')
          ..write('partsCost: $partsCost, ')
          ..write('totalCost: $totalCost, ')
          ..write('notes: $notes, ')
          ..write('reminderType: $reminderType, ')
          ..write('nextServiceOdometer: $nextServiceOdometer, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('whatsappEnabled: $whatsappEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    serviceDate,
    odometerReading,
    serviceType,
    description,
    oilBrand,
    laborCost,
    partsCost,
    totalCost,
    notes,
    reminderType,
    nextServiceOdometer,
    nextServiceDate,
    reminderEnabled,
    whatsappEnabled,
    createdAt,
    updatedAt,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceRecordRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.serviceDate == this.serviceDate &&
          other.odometerReading == this.odometerReading &&
          other.serviceType == this.serviceType &&
          other.description == this.description &&
          other.oilBrand == this.oilBrand &&
          other.laborCost == this.laborCost &&
          other.partsCost == this.partsCost &&
          other.totalCost == this.totalCost &&
          other.notes == this.notes &&
          other.reminderType == this.reminderType &&
          other.nextServiceOdometer == this.nextServiceOdometer &&
          other.nextServiceDate == this.nextServiceDate &&
          other.reminderEnabled == this.reminderEnabled &&
          other.whatsappEnabled == this.whatsappEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class ServiceRecordsCompanion extends UpdateCompanion<ServiceRecordRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<DateTime> serviceDate;
  final Value<int> odometerReading;
  final Value<String> serviceType;
  final Value<String?> description;
  final Value<String?> oilBrand;
  final Value<double> laborCost;
  final Value<double> partsCost;
  final Value<double> totalCost;
  final Value<String?> notes;
  final Value<String?> reminderType;
  final Value<int?> nextServiceOdometer;
  final Value<DateTime?> nextServiceDate;
  final Value<bool> reminderEnabled;
  final Value<bool> whatsappEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const ServiceRecordsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.serviceDate = const Value.absent(),
    this.odometerReading = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.description = const Value.absent(),
    this.oilBrand = const Value.absent(),
    this.laborCost = const Value.absent(),
    this.partsCost = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.nextServiceOdometer = const Value.absent(),
    this.nextServiceDate = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.whatsappEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceRecordsCompanion.insert({
    required String id,
    required String vehicleId,
    required DateTime serviceDate,
    required int odometerReading,
    required String serviceType,
    this.description = const Value.absent(),
    this.oilBrand = const Value.absent(),
    this.laborCost = const Value.absent(),
    this.partsCost = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.nextServiceOdometer = const Value.absent(),
    this.nextServiceDate = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.whatsappEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       serviceDate = Value(serviceDate),
       odometerReading = Value(odometerReading),
       serviceType = Value(serviceType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ServiceRecordRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<DateTime>? serviceDate,
    Expression<int>? odometerReading,
    Expression<String>? serviceType,
    Expression<String>? description,
    Expression<String>? oilBrand,
    Expression<double>? laborCost,
    Expression<double>? partsCost,
    Expression<double>? totalCost,
    Expression<String>? notes,
    Expression<String>? reminderType,
    Expression<int>? nextServiceOdometer,
    Expression<DateTime>? nextServiceDate,
    Expression<bool>? reminderEnabled,
    Expression<bool>? whatsappEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (serviceDate != null) 'service_date': serviceDate,
      if (odometerReading != null) 'odometer_reading': odometerReading,
      if (serviceType != null) 'service_type': serviceType,
      if (description != null) 'description': description,
      if (oilBrand != null) 'oil_brand': oilBrand,
      if (laborCost != null) 'labor_cost': laborCost,
      if (partsCost != null) 'parts_cost': partsCost,
      if (totalCost != null) 'total_cost': totalCost,
      if (notes != null) 'notes': notes,
      if (reminderType != null) 'reminder_type': reminderType,
      if (nextServiceOdometer != null)
        'next_service_odometer': nextServiceOdometer,
      if (nextServiceDate != null) 'next_service_date': nextServiceDate,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (whatsappEnabled != null) 'whatsapp_enabled': whatsappEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<DateTime>? serviceDate,
    Value<int>? odometerReading,
    Value<String>? serviceType,
    Value<String?>? description,
    Value<String?>? oilBrand,
    Value<double>? laborCost,
    Value<double>? partsCost,
    Value<double>? totalCost,
    Value<String?>? notes,
    Value<String?>? reminderType,
    Value<int?>? nextServiceOdometer,
    Value<DateTime?>? nextServiceDate,
    Value<bool>? reminderEnabled,
    Value<bool>? whatsappEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return ServiceRecordsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      serviceDate: serviceDate ?? this.serviceDate,
      odometerReading: odometerReading ?? this.odometerReading,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      oilBrand: oilBrand ?? this.oilBrand,
      laborCost: laborCost ?? this.laborCost,
      partsCost: partsCost ?? this.partsCost,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      reminderType: reminderType ?? this.reminderType,
      nextServiceOdometer: nextServiceOdometer ?? this.nextServiceOdometer,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (serviceDate.present) {
      map['service_date'] = Variable<DateTime>(serviceDate.value);
    }
    if (odometerReading.present) {
      map['odometer_reading'] = Variable<int>(odometerReading.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (oilBrand.present) {
      map['oil_brand'] = Variable<String>(oilBrand.value);
    }
    if (laborCost.present) {
      map['labor_cost'] = Variable<double>(laborCost.value);
    }
    if (partsCost.present) {
      map['parts_cost'] = Variable<double>(partsCost.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (nextServiceOdometer.present) {
      map['next_service_odometer'] = Variable<int>(nextServiceOdometer.value);
    }
    if (nextServiceDate.present) {
      map['next_service_date'] = Variable<DateTime>(nextServiceDate.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (whatsappEnabled.present) {
      map['whatsapp_enabled'] = Variable<bool>(whatsappEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('serviceDate: $serviceDate, ')
          ..write('odometerReading: $odometerReading, ')
          ..write('serviceType: $serviceType, ')
          ..write('description: $description, ')
          ..write('oilBrand: $oilBrand, ')
          ..write('laborCost: $laborCost, ')
          ..write('partsCost: $partsCost, ')
          ..write('totalCost: $totalCost, ')
          ..write('notes: $notes, ')
          ..write('reminderType: $reminderType, ')
          ..write('nextServiceOdometer: $nextServiceOdometer, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('whatsappEnabled: $whatsappEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRemindersTable extends MaintenanceReminders
    with TableInfo<$MaintenanceRemindersTable, MaintenanceReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _serviceRecordIdMeta = const VerificationMeta(
    'serviceRecordId',
  );
  @override
  late final GeneratedColumn<String> serviceRecordId = GeneratedColumn<String>(
    'service_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_records (id)',
    ),
  );
  static const VerificationMeta _currentOdometerMeta = const VerificationMeta(
    'currentOdometer',
  );
  @override
  late final GeneratedColumn<int> currentOdometer = GeneratedColumn<int>(
    'current_odometer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextServiceOdometerMeta =
      const VerificationMeta('nextServiceOdometer');
  @override
  late final GeneratedColumn<int> nextServiceOdometer = GeneratedColumn<int>(
    'next_service_odometer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastServiceDateMeta = const VerificationMeta(
    'lastServiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastServiceDate =
      GeneratedColumn<DateTime>(
        'last_service_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _nextServiceDateMeta = const VerificationMeta(
    'nextServiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextServiceDate =
      GeneratedColumn<DateTime>(
        'next_service_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reminderTypeMeta = const VerificationMeta(
    'reminderType',
  );
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
    'reminder_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReminderSentMeta = const VerificationMeta(
    'lastReminderSent',
  );
  @override
  late final GeneratedColumn<DateTime> lastReminderSent =
      GeneratedColumn<DateTime>(
        'last_reminder_sent',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notificationEnabledMeta =
      const VerificationMeta('notificationEnabled');
  @override
  late final GeneratedColumn<bool> notificationEnabled = GeneratedColumn<bool>(
    'notification_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notification_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _whatsappEnabledMeta = const VerificationMeta(
    'whatsappEnabled',
  );
  @override
  late final GeneratedColumn<bool> whatsappEnabled = GeneratedColumn<bool>(
    'whatsapp_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("whatsapp_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    serviceRecordId,
    currentOdometer,
    nextServiceOdometer,
    lastServiceDate,
    nextServiceDate,
    reminderType,
    status,
    lastReminderSent,
    notificationEnabled,
    whatsappEnabled,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('service_record_id')) {
      context.handle(
        _serviceRecordIdMeta,
        serviceRecordId.isAcceptableOrUnknown(
          data['service_record_id']!,
          _serviceRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceRecordIdMeta);
    }
    if (data.containsKey('current_odometer')) {
      context.handle(
        _currentOdometerMeta,
        currentOdometer.isAcceptableOrUnknown(
          data['current_odometer']!,
          _currentOdometerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentOdometerMeta);
    }
    if (data.containsKey('next_service_odometer')) {
      context.handle(
        _nextServiceOdometerMeta,
        nextServiceOdometer.isAcceptableOrUnknown(
          data['next_service_odometer']!,
          _nextServiceOdometerMeta,
        ),
      );
    }
    if (data.containsKey('last_service_date')) {
      context.handle(
        _lastServiceDateMeta,
        lastServiceDate.isAcceptableOrUnknown(
          data['last_service_date']!,
          _lastServiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastServiceDateMeta);
    }
    if (data.containsKey('next_service_date')) {
      context.handle(
        _nextServiceDateMeta,
        nextServiceDate.isAcceptableOrUnknown(
          data['next_service_date']!,
          _nextServiceDateMeta,
        ),
      );
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
        _reminderTypeMeta,
        reminderType.isAcceptableOrUnknown(
          data['reminder_type']!,
          _reminderTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_reminder_sent')) {
      context.handle(
        _lastReminderSentMeta,
        lastReminderSent.isAcceptableOrUnknown(
          data['last_reminder_sent']!,
          _lastReminderSentMeta,
        ),
      );
    }
    if (data.containsKey('notification_enabled')) {
      context.handle(
        _notificationEnabledMeta,
        notificationEnabled.isAcceptableOrUnknown(
          data['notification_enabled']!,
          _notificationEnabledMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_enabled')) {
      context.handle(
        _whatsappEnabledMeta,
        whatsappEnabled.isAcceptableOrUnknown(
          data['whatsapp_enabled']!,
          _whatsappEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      serviceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_record_id'],
      )!,
      currentOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_odometer'],
      )!,
      nextServiceOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_service_odometer'],
      ),
      lastServiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_service_date'],
      )!,
      nextServiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_service_date'],
      ),
      reminderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastReminderSent: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reminder_sent'],
      ),
      notificationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_enabled'],
      )!,
      whatsappEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}whatsapp_enabled'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MaintenanceRemindersTable createAlias(String alias) {
    return $MaintenanceRemindersTable(attachedDatabase, alias);
  }
}

class MaintenanceReminderRow extends DataClass
    implements Insertable<MaintenanceReminderRow> {
  final String id;
  final String vehicleId;
  final String serviceRecordId;
  final int currentOdometer;
  final int? nextServiceOdometer;
  final DateTime lastServiceDate;
  final DateTime? nextServiceDate;

  /// km | date | both
  final String reminderType;

  /// upcoming | due | overdue | completed
  final String status;
  final DateTime? lastReminderSent;
  final bool notificationEnabled;
  final bool whatsappEnabled;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MaintenanceReminderRow({
    required this.id,
    required this.vehicleId,
    required this.serviceRecordId,
    required this.currentOdometer,
    this.nextServiceOdometer,
    required this.lastServiceDate,
    this.nextServiceDate,
    required this.reminderType,
    required this.status,
    this.lastReminderSent,
    required this.notificationEnabled,
    required this.whatsappEnabled,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['service_record_id'] = Variable<String>(serviceRecordId);
    map['current_odometer'] = Variable<int>(currentOdometer);
    if (!nullToAbsent || nextServiceOdometer != null) {
      map['next_service_odometer'] = Variable<int>(nextServiceOdometer);
    }
    map['last_service_date'] = Variable<DateTime>(lastServiceDate);
    if (!nullToAbsent || nextServiceDate != null) {
      map['next_service_date'] = Variable<DateTime>(nextServiceDate);
    }
    map['reminder_type'] = Variable<String>(reminderType);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastReminderSent != null) {
      map['last_reminder_sent'] = Variable<DateTime>(lastReminderSent);
    }
    map['notification_enabled'] = Variable<bool>(notificationEnabled);
    map['whatsapp_enabled'] = Variable<bool>(whatsappEnabled);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MaintenanceRemindersCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRemindersCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      serviceRecordId: Value(serviceRecordId),
      currentOdometer: Value(currentOdometer),
      nextServiceOdometer: nextServiceOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceOdometer),
      lastServiceDate: Value(lastServiceDate),
      nextServiceDate: nextServiceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceDate),
      reminderType: Value(reminderType),
      status: Value(status),
      lastReminderSent: lastReminderSent == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReminderSent),
      notificationEnabled: Value(notificationEnabled),
      whatsappEnabled: Value(whatsappEnabled),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MaintenanceReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceReminderRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      serviceRecordId: serializer.fromJson<String>(json['serviceRecordId']),
      currentOdometer: serializer.fromJson<int>(json['currentOdometer']),
      nextServiceOdometer: serializer.fromJson<int?>(
        json['nextServiceOdometer'],
      ),
      lastServiceDate: serializer.fromJson<DateTime>(json['lastServiceDate']),
      nextServiceDate: serializer.fromJson<DateTime?>(json['nextServiceDate']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      status: serializer.fromJson<String>(json['status']),
      lastReminderSent: serializer.fromJson<DateTime?>(
        json['lastReminderSent'],
      ),
      notificationEnabled: serializer.fromJson<bool>(
        json['notificationEnabled'],
      ),
      whatsappEnabled: serializer.fromJson<bool>(json['whatsappEnabled']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'serviceRecordId': serializer.toJson<String>(serviceRecordId),
      'currentOdometer': serializer.toJson<int>(currentOdometer),
      'nextServiceOdometer': serializer.toJson<int?>(nextServiceOdometer),
      'lastServiceDate': serializer.toJson<DateTime>(lastServiceDate),
      'nextServiceDate': serializer.toJson<DateTime?>(nextServiceDate),
      'reminderType': serializer.toJson<String>(reminderType),
      'status': serializer.toJson<String>(status),
      'lastReminderSent': serializer.toJson<DateTime?>(lastReminderSent),
      'notificationEnabled': serializer.toJson<bool>(notificationEnabled),
      'whatsappEnabled': serializer.toJson<bool>(whatsappEnabled),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MaintenanceReminderRow copyWith({
    String? id,
    String? vehicleId,
    String? serviceRecordId,
    int? currentOdometer,
    Value<int?> nextServiceOdometer = const Value.absent(),
    DateTime? lastServiceDate,
    Value<DateTime?> nextServiceDate = const Value.absent(),
    String? reminderType,
    String? status,
    Value<DateTime?> lastReminderSent = const Value.absent(),
    bool? notificationEnabled,
    bool? whatsappEnabled,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MaintenanceReminderRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    serviceRecordId: serviceRecordId ?? this.serviceRecordId,
    currentOdometer: currentOdometer ?? this.currentOdometer,
    nextServiceOdometer: nextServiceOdometer.present
        ? nextServiceOdometer.value
        : this.nextServiceOdometer,
    lastServiceDate: lastServiceDate ?? this.lastServiceDate,
    nextServiceDate: nextServiceDate.present
        ? nextServiceDate.value
        : this.nextServiceDate,
    reminderType: reminderType ?? this.reminderType,
    status: status ?? this.status,
    lastReminderSent: lastReminderSent.present
        ? lastReminderSent.value
        : this.lastReminderSent,
    notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MaintenanceReminderRow copyWithCompanion(MaintenanceRemindersCompanion data) {
    return MaintenanceReminderRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      serviceRecordId: data.serviceRecordId.present
          ? data.serviceRecordId.value
          : this.serviceRecordId,
      currentOdometer: data.currentOdometer.present
          ? data.currentOdometer.value
          : this.currentOdometer,
      nextServiceOdometer: data.nextServiceOdometer.present
          ? data.nextServiceOdometer.value
          : this.nextServiceOdometer,
      lastServiceDate: data.lastServiceDate.present
          ? data.lastServiceDate.value
          : this.lastServiceDate,
      nextServiceDate: data.nextServiceDate.present
          ? data.nextServiceDate.value
          : this.nextServiceDate,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      status: data.status.present ? data.status.value : this.status,
      lastReminderSent: data.lastReminderSent.present
          ? data.lastReminderSent.value
          : this.lastReminderSent,
      notificationEnabled: data.notificationEnabled.present
          ? data.notificationEnabled.value
          : this.notificationEnabled,
      whatsappEnabled: data.whatsappEnabled.present
          ? data.whatsappEnabled.value
          : this.whatsappEnabled,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceReminderRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('currentOdometer: $currentOdometer, ')
          ..write('nextServiceOdometer: $nextServiceOdometer, ')
          ..write('lastServiceDate: $lastServiceDate, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('reminderType: $reminderType, ')
          ..write('status: $status, ')
          ..write('lastReminderSent: $lastReminderSent, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('whatsappEnabled: $whatsappEnabled, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    serviceRecordId,
    currentOdometer,
    nextServiceOdometer,
    lastServiceDate,
    nextServiceDate,
    reminderType,
    status,
    lastReminderSent,
    notificationEnabled,
    whatsappEnabled,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceReminderRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.serviceRecordId == this.serviceRecordId &&
          other.currentOdometer == this.currentOdometer &&
          other.nextServiceOdometer == this.nextServiceOdometer &&
          other.lastServiceDate == this.lastServiceDate &&
          other.nextServiceDate == this.nextServiceDate &&
          other.reminderType == this.reminderType &&
          other.status == this.status &&
          other.lastReminderSent == this.lastReminderSent &&
          other.notificationEnabled == this.notificationEnabled &&
          other.whatsappEnabled == this.whatsappEnabled &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MaintenanceRemindersCompanion
    extends UpdateCompanion<MaintenanceReminderRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> serviceRecordId;
  final Value<int> currentOdometer;
  final Value<int?> nextServiceOdometer;
  final Value<DateTime> lastServiceDate;
  final Value<DateTime?> nextServiceDate;
  final Value<String> reminderType;
  final Value<String> status;
  final Value<DateTime?> lastReminderSent;
  final Value<bool> notificationEnabled;
  final Value<bool> whatsappEnabled;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MaintenanceRemindersCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.serviceRecordId = const Value.absent(),
    this.currentOdometer = const Value.absent(),
    this.nextServiceOdometer = const Value.absent(),
    this.lastServiceDate = const Value.absent(),
    this.nextServiceDate = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.status = const Value.absent(),
    this.lastReminderSent = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.whatsappEnabled = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceRemindersCompanion.insert({
    required String id,
    required String vehicleId,
    required String serviceRecordId,
    required int currentOdometer,
    this.nextServiceOdometer = const Value.absent(),
    required DateTime lastServiceDate,
    this.nextServiceDate = const Value.absent(),
    required String reminderType,
    required String status,
    this.lastReminderSent = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.whatsappEnabled = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       serviceRecordId = Value(serviceRecordId),
       currentOdometer = Value(currentOdometer),
       lastServiceDate = Value(lastServiceDate),
       reminderType = Value(reminderType),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MaintenanceReminderRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? serviceRecordId,
    Expression<int>? currentOdometer,
    Expression<int>? nextServiceOdometer,
    Expression<DateTime>? lastServiceDate,
    Expression<DateTime>? nextServiceDate,
    Expression<String>? reminderType,
    Expression<String>? status,
    Expression<DateTime>? lastReminderSent,
    Expression<bool>? notificationEnabled,
    Expression<bool>? whatsappEnabled,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (serviceRecordId != null) 'service_record_id': serviceRecordId,
      if (currentOdometer != null) 'current_odometer': currentOdometer,
      if (nextServiceOdometer != null)
        'next_service_odometer': nextServiceOdometer,
      if (lastServiceDate != null) 'last_service_date': lastServiceDate,
      if (nextServiceDate != null) 'next_service_date': nextServiceDate,
      if (reminderType != null) 'reminder_type': reminderType,
      if (status != null) 'status': status,
      if (lastReminderSent != null) 'last_reminder_sent': lastReminderSent,
      if (notificationEnabled != null)
        'notification_enabled': notificationEnabled,
      if (whatsappEnabled != null) 'whatsapp_enabled': whatsappEnabled,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceRemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? serviceRecordId,
    Value<int>? currentOdometer,
    Value<int?>? nextServiceOdometer,
    Value<DateTime>? lastServiceDate,
    Value<DateTime?>? nextServiceDate,
    Value<String>? reminderType,
    Value<String>? status,
    Value<DateTime?>? lastReminderSent,
    Value<bool>? notificationEnabled,
    Value<bool>? whatsappEnabled,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MaintenanceRemindersCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      nextServiceOdometer: nextServiceOdometer ?? this.nextServiceOdometer,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      reminderType: reminderType ?? this.reminderType,
      status: status ?? this.status,
      lastReminderSent: lastReminderSent ?? this.lastReminderSent,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (serviceRecordId.present) {
      map['service_record_id'] = Variable<String>(serviceRecordId.value);
    }
    if (currentOdometer.present) {
      map['current_odometer'] = Variable<int>(currentOdometer.value);
    }
    if (nextServiceOdometer.present) {
      map['next_service_odometer'] = Variable<int>(nextServiceOdometer.value);
    }
    if (lastServiceDate.present) {
      map['last_service_date'] = Variable<DateTime>(lastServiceDate.value);
    }
    if (nextServiceDate.present) {
      map['next_service_date'] = Variable<DateTime>(nextServiceDate.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastReminderSent.present) {
      map['last_reminder_sent'] = Variable<DateTime>(lastReminderSent.value);
    }
    if (notificationEnabled.present) {
      map['notification_enabled'] = Variable<bool>(notificationEnabled.value);
    }
    if (whatsappEnabled.present) {
      map['whatsapp_enabled'] = Variable<bool>(whatsappEnabled.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRemindersCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('currentOdometer: $currentOdometer, ')
          ..write('nextServiceOdometer: $nextServiceOdometer, ')
          ..write('lastServiceDate: $lastServiceDate, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('reminderType: $reminderType, ')
          ..write('status: $status, ')
          ..write('lastReminderSent: $lastReminderSent, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('whatsappEnabled: $whatsappEnabled, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageTemplatesTable extends MessageTemplates
    with TableInfo<$MessageTemplatesTable, MessageTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('custom'),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    body,
    category,
    isDefault,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageTemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MessageTemplatesTable createAlias(String alias) {
    return $MessageTemplatesTable(attachedDatabase, alias);
  }
}

class MessageTemplateRow extends DataClass
    implements Insertable<MessageTemplateRow> {
  final String id;
  final String name;

  /// Template body with placeholders like {{CustomerName}}.
  final String body;

  /// oil_change | regular_maintenance | overdue | thank_you | custom
  final String category;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MessageTemplateRow({
    required this.id,
    required this.name,
    required this.body,
    required this.category,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['body'] = Variable<String>(body);
    map['category'] = Variable<String>(category);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MessageTemplatesCompanion toCompanion(bool nullToAbsent) {
    return MessageTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      body: Value(body),
      category: Value(category),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MessageTemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTemplateRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      body: serializer.fromJson<String>(json['body']),
      category: serializer.fromJson<String>(json['category']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'body': serializer.toJson<String>(body),
      'category': serializer.toJson<String>(category),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MessageTemplateRow copyWith({
    String? id,
    String? name,
    String? body,
    String? category,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MessageTemplateRow(
    id: id ?? this.id,
    name: name ?? this.name,
    body: body ?? this.body,
    category: category ?? this.category,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MessageTemplateRow copyWithCompanion(MessageTemplatesCompanion data) {
    return MessageTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      body: data.body.present ? data.body.value : this.body,
      category: data.category.present ? data.category.value : this.category,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageTemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('body: $body, ')
          ..write('category: $category, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, body, category, isDefault, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.body == this.body &&
          other.category == this.category &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MessageTemplatesCompanion extends UpdateCompanion<MessageTemplateRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> body;
  final Value<String> category;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MessageTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.body = const Value.absent(),
    this.category = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageTemplatesCompanion.insert({
    required String id,
    required String name,
    required String body,
    this.category = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       body = Value(body),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MessageTemplateRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? body,
    Expression<String>? category,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (body != null) 'body': body,
      if (category != null) 'category': category,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? body,
    Value<String>? category,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MessageTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      body: body ?? this.body,
      category: category ?? this.category,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('body: $body, ')
          ..write('category: $category, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderHistoryTable extends ReminderHistory
    with TableInfo<$ReminderHistoryTable, ReminderHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reminderId,
    vehicleId,
    customerId,
    actionType,
    title,
    details,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      ),
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReminderHistoryTable createAlias(String alias) {
    return $ReminderHistoryTable(attachedDatabase, alias);
  }
}

class ReminderHistoryRow extends DataClass
    implements Insertable<ReminderHistoryRow> {
  final String id;
  final String? reminderId;
  final String? vehicleId;
  final String? customerId;

  /// reminder_sent | notification_sent | whatsapp_opened | completed | dismissed
  final String actionType;
  final String? title;
  final String? details;
  final DateTime createdAt;
  const ReminderHistoryRow({
    required this.id,
    this.reminderId,
    this.vehicleId,
    this.customerId,
    required this.actionType,
    this.title,
    this.details,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<String>(reminderId);
    }
    if (!nullToAbsent || vehicleId != null) {
      map['vehicle_id'] = Variable<String>(vehicleId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReminderHistoryCompanion toCompanion(bool nullToAbsent) {
    return ReminderHistoryCompanion(
      id: Value(id),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
      vehicleId: vehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      actionType: Value(actionType),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory ReminderHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      reminderId: serializer.fromJson<String?>(json['reminderId']),
      vehicleId: serializer.fromJson<String?>(json['vehicleId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      title: serializer.fromJson<String?>(json['title']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reminderId': serializer.toJson<String?>(reminderId),
      'vehicleId': serializer.toJson<String?>(vehicleId),
      'customerId': serializer.toJson<String?>(customerId),
      'actionType': serializer.toJson<String>(actionType),
      'title': serializer.toJson<String?>(title),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReminderHistoryRow copyWith({
    String? id,
    Value<String?> reminderId = const Value.absent(),
    Value<String?> vehicleId = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    String? actionType,
    Value<String?> title = const Value.absent(),
    Value<String?> details = const Value.absent(),
    DateTime? createdAt,
  }) => ReminderHistoryRow(
    id: id ?? this.id,
    reminderId: reminderId.present ? reminderId.value : this.reminderId,
    vehicleId: vehicleId.present ? vehicleId.value : this.vehicleId,
    customerId: customerId.present ? customerId.value : this.customerId,
    actionType: actionType ?? this.actionType,
    title: title.present ? title.value : this.title,
    details: details.present ? details.value : this.details,
    createdAt: createdAt ?? this.createdAt,
  );
  ReminderHistoryRow copyWithCompanion(ReminderHistoryCompanion data) {
    return ReminderHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      title: data.title.present ? data.title.value : this.title,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderHistoryRow(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('customerId: $customerId, ')
          ..write('actionType: $actionType, ')
          ..write('title: $title, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reminderId,
    vehicleId,
    customerId,
    actionType,
    title,
    details,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderHistoryRow &&
          other.id == this.id &&
          other.reminderId == this.reminderId &&
          other.vehicleId == this.vehicleId &&
          other.customerId == this.customerId &&
          other.actionType == this.actionType &&
          other.title == this.title &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class ReminderHistoryCompanion extends UpdateCompanion<ReminderHistoryRow> {
  final Value<String> id;
  final Value<String?> reminderId;
  final Value<String?> vehicleId;
  final Value<String?> customerId;
  final Value<String> actionType;
  final Value<String?> title;
  final Value<String?> details;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReminderHistoryCompanion({
    this.id = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.title = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderHistoryCompanion.insert({
    required String id,
    this.reminderId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.customerId = const Value.absent(),
    required String actionType,
    this.title = const Value.absent(),
    this.details = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       actionType = Value(actionType),
       createdAt = Value(createdAt);
  static Insertable<ReminderHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? reminderId,
    Expression<String>? vehicleId,
    Expression<String>? customerId,
    Expression<String>? actionType,
    Expression<String>? title,
    Expression<String>? details,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reminderId != null) 'reminder_id': reminderId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (customerId != null) 'customer_id': customerId,
      if (actionType != null) 'action_type': actionType,
      if (title != null) 'title': title,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderHistoryCompanion copyWith({
    Value<String>? id,
    Value<String?>? reminderId,
    Value<String?>? vehicleId,
    Value<String?>? customerId,
    Value<String>? actionType,
    Value<String?>? title,
    Value<String?>? details,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReminderHistoryCompanion(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      actionType: actionType ?? this.actionType,
      title: title ?? this.title,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderHistoryCompanion(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('customerId: $customerId, ')
          ..write('actionType: $actionType, ')
          ..write('title: $title, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices
    with TableInfo<$InvoicesTable, InvoiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceRecordIdMeta = const VerificationMeta(
    'serviceRecordId',
  );
  @override
  late final GeneratedColumn<String> serviceRecordId = GeneratedColumn<String>(
    'service_record_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceDateMeta = const VerificationMeta(
    'invoiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> invoiceDate = GeneratedColumn<DateTime>(
    'invoice_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<double> tax = GeneratedColumn<double>(
    'tax',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cash'),
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
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
  static const VerificationMeta _labourDescriptionMeta = const VerificationMeta(
    'labourDescription',
  );
  @override
  late final GeneratedColumn<String> labourDescription =
      GeneratedColumn<String>(
        'labour_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _labourAmountMeta = const VerificationMeta(
    'labourAmount',
  );
  @override
  late final GeneratedColumn<double> labourAmount = GeneratedColumn<double>(
    'labour_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _partsDescriptionMeta = const VerificationMeta(
    'partsDescription',
  );
  @override
  late final GeneratedColumn<String> partsDescription = GeneratedColumn<String>(
    'parts_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partsAmountMeta = const VerificationMeta(
    'partsAmount',
  );
  @override
  late final GeneratedColumn<double> partsAmount = GeneratedColumn<double>(
    'parts_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serviceDescriptionMeta =
      const VerificationMeta('serviceDescription');
  @override
  late final GeneratedColumn<String> serviceDescription =
      GeneratedColumn<String>(
        'service_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serviceRecordId,
    customerId,
    vehicleId,
    invoiceNumber,
    invoiceDate,
    subtotal,
    discount,
    tax,
    grandTotal,
    paymentMethod,
    paymentStatus,
    paidDate,
    currency,
    notes,
    labourDescription,
    labourAmount,
    partsDescription,
    partsAmount,
    serviceDescription,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('service_record_id')) {
      context.handle(
        _serviceRecordIdMeta,
        serviceRecordId.isAcceptableOrUnknown(
          data['service_record_id']!,
          _serviceRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
        _invoiceDateMeta,
        invoiceDate.isAcceptableOrUnknown(
          data['invoice_date']!,
          _invoiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('tax')) {
      context.handle(
        _taxMeta,
        tax.isAcceptableOrUnknown(data['tax']!, _taxMeta),
      );
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('labour_description')) {
      context.handle(
        _labourDescriptionMeta,
        labourDescription.isAcceptableOrUnknown(
          data['labour_description']!,
          _labourDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('labour_amount')) {
      context.handle(
        _labourAmountMeta,
        labourAmount.isAcceptableOrUnknown(
          data['labour_amount']!,
          _labourAmountMeta,
        ),
      );
    }
    if (data.containsKey('parts_description')) {
      context.handle(
        _partsDescriptionMeta,
        partsDescription.isAcceptableOrUnknown(
          data['parts_description']!,
          _partsDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('parts_amount')) {
      context.handle(
        _partsAmountMeta,
        partsAmount.isAcceptableOrUnknown(
          data['parts_amount']!,
          _partsAmountMeta,
        ),
      );
    }
    if (data.containsKey('service_description')) {
      context.handle(
        _serviceDescriptionMeta,
        serviceDescription.isAcceptableOrUnknown(
          data['service_description']!,
          _serviceDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serviceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_record_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      invoiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}invoice_date'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount'],
      )!,
      tax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax'],
      )!,
      grandTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grand_total'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      labourDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}labour_description'],
      ),
      labourAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}labour_amount'],
      )!,
      partsDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parts_description'],
      ),
      partsAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}parts_amount'],
      )!,
      serviceDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class InvoiceRow extends DataClass implements Insertable<InvoiceRow> {
  final String id;
  final String? serviceRecordId;
  final String customerId;
  final String vehicleId;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;

  /// cash | card | bank_transfer | online | other
  final String paymentMethod;

  /// paid | pending | partially_paid | cancelled
  final String paymentStatus;
  final DateTime? paidDate;
  final String currency;
  final String? notes;

  /// Snapshot fields for offline invoice rendering.
  final String? labourDescription;
  final double labourAmount;
  final String? partsDescription;
  final double partsAmount;
  final String? serviceDescription;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InvoiceRow({
    required this.id,
    this.serviceRecordId,
    required this.customerId,
    required this.vehicleId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paidDate,
    required this.currency,
    this.notes,
    this.labourDescription,
    required this.labourAmount,
    this.partsDescription,
    required this.partsAmount,
    this.serviceDescription,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serviceRecordId != null) {
      map['service_record_id'] = Variable<String>(serviceRecordId);
    }
    map['customer_id'] = Variable<String>(customerId);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['invoice_date'] = Variable<DateTime>(invoiceDate);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount'] = Variable<double>(discount);
    map['tax'] = Variable<double>(tax);
    map['grand_total'] = Variable<double>(grandTotal);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || labourDescription != null) {
      map['labour_description'] = Variable<String>(labourDescription);
    }
    map['labour_amount'] = Variable<double>(labourAmount);
    if (!nullToAbsent || partsDescription != null) {
      map['parts_description'] = Variable<String>(partsDescription);
    }
    map['parts_amount'] = Variable<double>(partsAmount);
    if (!nullToAbsent || serviceDescription != null) {
      map['service_description'] = Variable<String>(serviceDescription);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      serviceRecordId: serviceRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceRecordId),
      customerId: Value(customerId),
      vehicleId: Value(vehicleId),
      invoiceNumber: Value(invoiceNumber),
      invoiceDate: Value(invoiceDate),
      subtotal: Value(subtotal),
      discount: Value(discount),
      tax: Value(tax),
      grandTotal: Value(grandTotal),
      paymentMethod: Value(paymentMethod),
      paymentStatus: Value(paymentStatus),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      currency: Value(currency),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      labourDescription: labourDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(labourDescription),
      labourAmount: Value(labourAmount),
      partsDescription: partsDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(partsDescription),
      partsAmount: Value(partsAmount),
      serviceDescription: serviceDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceDescription),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InvoiceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceRow(
      id: serializer.fromJson<String>(json['id']),
      serviceRecordId: serializer.fromJson<String?>(json['serviceRecordId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      invoiceDate: serializer.fromJson<DateTime>(json['invoiceDate']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discount: serializer.fromJson<double>(json['discount']),
      tax: serializer.fromJson<double>(json['tax']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
      currency: serializer.fromJson<String>(json['currency']),
      notes: serializer.fromJson<String?>(json['notes']),
      labourDescription: serializer.fromJson<String?>(
        json['labourDescription'],
      ),
      labourAmount: serializer.fromJson<double>(json['labourAmount']),
      partsDescription: serializer.fromJson<String?>(json['partsDescription']),
      partsAmount: serializer.fromJson<double>(json['partsAmount']),
      serviceDescription: serializer.fromJson<String?>(
        json['serviceDescription'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serviceRecordId': serializer.toJson<String?>(serviceRecordId),
      'customerId': serializer.toJson<String>(customerId),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'invoiceDate': serializer.toJson<DateTime>(invoiceDate),
      'subtotal': serializer.toJson<double>(subtotal),
      'discount': serializer.toJson<double>(discount),
      'tax': serializer.toJson<double>(tax),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
      'currency': serializer.toJson<String>(currency),
      'notes': serializer.toJson<String?>(notes),
      'labourDescription': serializer.toJson<String?>(labourDescription),
      'labourAmount': serializer.toJson<double>(labourAmount),
      'partsDescription': serializer.toJson<String?>(partsDescription),
      'partsAmount': serializer.toJson<double>(partsAmount),
      'serviceDescription': serializer.toJson<String?>(serviceDescription),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InvoiceRow copyWith({
    String? id,
    Value<String?> serviceRecordId = const Value.absent(),
    String? customerId,
    String? vehicleId,
    String? invoiceNumber,
    DateTime? invoiceDate,
    double? subtotal,
    double? discount,
    double? tax,
    double? grandTotal,
    String? paymentMethod,
    String? paymentStatus,
    Value<DateTime?> paidDate = const Value.absent(),
    String? currency,
    Value<String?> notes = const Value.absent(),
    Value<String?> labourDescription = const Value.absent(),
    double? labourAmount,
    Value<String?> partsDescription = const Value.absent(),
    double? partsAmount,
    Value<String?> serviceDescription = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InvoiceRow(
    id: id ?? this.id,
    serviceRecordId: serviceRecordId.present
        ? serviceRecordId.value
        : this.serviceRecordId,
    customerId: customerId ?? this.customerId,
    vehicleId: vehicleId ?? this.vehicleId,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    subtotal: subtotal ?? this.subtotal,
    discount: discount ?? this.discount,
    tax: tax ?? this.tax,
    grandTotal: grandTotal ?? this.grandTotal,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    currency: currency ?? this.currency,
    notes: notes.present ? notes.value : this.notes,
    labourDescription: labourDescription.present
        ? labourDescription.value
        : this.labourDescription,
    labourAmount: labourAmount ?? this.labourAmount,
    partsDescription: partsDescription.present
        ? partsDescription.value
        : this.partsDescription,
    partsAmount: partsAmount ?? this.partsAmount,
    serviceDescription: serviceDescription.present
        ? serviceDescription.value
        : this.serviceDescription,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InvoiceRow copyWithCompanion(InvoicesCompanion data) {
    return InvoiceRow(
      id: data.id.present ? data.id.value : this.id,
      serviceRecordId: data.serviceRecordId.present
          ? data.serviceRecordId.value
          : this.serviceRecordId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      invoiceDate: data.invoiceDate.present
          ? data.invoiceDate.value
          : this.invoiceDate,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      tax: data.tax.present ? data.tax.value : this.tax,
      grandTotal: data.grandTotal.present
          ? data.grandTotal.value
          : this.grandTotal,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      currency: data.currency.present ? data.currency.value : this.currency,
      notes: data.notes.present ? data.notes.value : this.notes,
      labourDescription: data.labourDescription.present
          ? data.labourDescription.value
          : this.labourDescription,
      labourAmount: data.labourAmount.present
          ? data.labourAmount.value
          : this.labourAmount,
      partsDescription: data.partsDescription.present
          ? data.partsDescription.value
          : this.partsDescription,
      partsAmount: data.partsAmount.present
          ? data.partsAmount.value
          : this.partsAmount,
      serviceDescription: data.serviceDescription.present
          ? data.serviceDescription.value
          : this.serviceDescription,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceRow(')
          ..write('id: $id, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('customerId: $customerId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paidDate: $paidDate, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('labourDescription: $labourDescription, ')
          ..write('labourAmount: $labourAmount, ')
          ..write('partsDescription: $partsDescription, ')
          ..write('partsAmount: $partsAmount, ')
          ..write('serviceDescription: $serviceDescription, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serviceRecordId,
    customerId,
    vehicleId,
    invoiceNumber,
    invoiceDate,
    subtotal,
    discount,
    tax,
    grandTotal,
    paymentMethod,
    paymentStatus,
    paidDate,
    currency,
    notes,
    labourDescription,
    labourAmount,
    partsDescription,
    partsAmount,
    serviceDescription,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceRow &&
          other.id == this.id &&
          other.serviceRecordId == this.serviceRecordId &&
          other.customerId == this.customerId &&
          other.vehicleId == this.vehicleId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.invoiceDate == this.invoiceDate &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.tax == this.tax &&
          other.grandTotal == this.grandTotal &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentStatus == this.paymentStatus &&
          other.paidDate == this.paidDate &&
          other.currency == this.currency &&
          other.notes == this.notes &&
          other.labourDescription == this.labourDescription &&
          other.labourAmount == this.labourAmount &&
          other.partsDescription == this.partsDescription &&
          other.partsAmount == this.partsAmount &&
          other.serviceDescription == this.serviceDescription &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<InvoiceRow> {
  final Value<String> id;
  final Value<String?> serviceRecordId;
  final Value<String> customerId;
  final Value<String> vehicleId;
  final Value<String> invoiceNumber;
  final Value<DateTime> invoiceDate;
  final Value<double> subtotal;
  final Value<double> discount;
  final Value<double> tax;
  final Value<double> grandTotal;
  final Value<String> paymentMethod;
  final Value<String> paymentStatus;
  final Value<DateTime?> paidDate;
  final Value<String> currency;
  final Value<String?> notes;
  final Value<String?> labourDescription;
  final Value<double> labourAmount;
  final Value<String?> partsDescription;
  final Value<double> partsAmount;
  final Value<String?> serviceDescription;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.serviceRecordId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.labourDescription = const Value.absent(),
    this.labourAmount = const Value.absent(),
    this.partsDescription = const Value.absent(),
    this.partsAmount = const Value.absent(),
    this.serviceDescription = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    this.serviceRecordId = const Value.absent(),
    required String customerId,
    required String vehicleId,
    required String invoiceNumber,
    required DateTime invoiceDate,
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.labourDescription = const Value.absent(),
    this.labourAmount = const Value.absent(),
    this.partsDescription = const Value.absent(),
    this.partsAmount = const Value.absent(),
    this.serviceDescription = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       vehicleId = Value(vehicleId),
       invoiceNumber = Value(invoiceNumber),
       invoiceDate = Value(invoiceDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InvoiceRow> custom({
    Expression<String>? id,
    Expression<String>? serviceRecordId,
    Expression<String>? customerId,
    Expression<String>? vehicleId,
    Expression<String>? invoiceNumber,
    Expression<DateTime>? invoiceDate,
    Expression<double>? subtotal,
    Expression<double>? discount,
    Expression<double>? tax,
    Expression<double>? grandTotal,
    Expression<String>? paymentMethod,
    Expression<String>? paymentStatus,
    Expression<DateTime>? paidDate,
    Expression<String>? currency,
    Expression<String>? notes,
    Expression<String>? labourDescription,
    Expression<double>? labourAmount,
    Expression<String>? partsDescription,
    Expression<double>? partsAmount,
    Expression<String>? serviceDescription,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceRecordId != null) 'service_record_id': serviceRecordId,
      if (customerId != null) 'customer_id': customerId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (paidDate != null) 'paid_date': paidDate,
      if (currency != null) 'currency': currency,
      if (notes != null) 'notes': notes,
      if (labourDescription != null) 'labour_description': labourDescription,
      if (labourAmount != null) 'labour_amount': labourAmount,
      if (partsDescription != null) 'parts_description': partsDescription,
      if (partsAmount != null) 'parts_amount': partsAmount,
      if (serviceDescription != null) 'service_description': serviceDescription,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<String>? id,
    Value<String?>? serviceRecordId,
    Value<String>? customerId,
    Value<String>? vehicleId,
    Value<String>? invoiceNumber,
    Value<DateTime>? invoiceDate,
    Value<double>? subtotal,
    Value<double>? discount,
    Value<double>? tax,
    Value<double>? grandTotal,
    Value<String>? paymentMethod,
    Value<String>? paymentStatus,
    Value<DateTime?>? paidDate,
    Value<String>? currency,
    Value<String?>? notes,
    Value<String?>? labourDescription,
    Value<double>? labourAmount,
    Value<String?>? partsDescription,
    Value<double>? partsAmount,
    Value<String?>? serviceDescription,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      customerId: customerId ?? this.customerId,
      vehicleId: vehicleId ?? this.vehicleId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paidDate: paidDate ?? this.paidDate,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      labourDescription: labourDescription ?? this.labourDescription,
      labourAmount: labourAmount ?? this.labourAmount,
      partsDescription: partsDescription ?? this.partsDescription,
      partsAmount: partsAmount ?? this.partsAmount,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serviceRecordId.present) {
      map['service_record_id'] = Variable<String>(serviceRecordId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<DateTime>(invoiceDate.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (tax.present) {
      map['tax'] = Variable<double>(tax.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (labourDescription.present) {
      map['labour_description'] = Variable<String>(labourDescription.value);
    }
    if (labourAmount.present) {
      map['labour_amount'] = Variable<double>(labourAmount.value);
    }
    if (partsDescription.present) {
      map['parts_description'] = Variable<String>(partsDescription.value);
    }
    if (partsAmount.present) {
      map['parts_amount'] = Variable<double>(partsAmount.value);
    }
    if (serviceDescription.present) {
      map['service_description'] = Variable<String>(serviceDescription.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('customerId: $customerId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paidDate: $paidDate, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('labourDescription: $labourDescription, ')
          ..write('labourAmount: $labourAmount, ')
          ..write('partsDescription: $partsDescription, ')
          ..write('partsAmount: $partsAmount, ')
          ..write('serviceDescription: $serviceDescription, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _quantityAvailableMeta = const VerificationMeta(
    'quantityAvailable',
  );
  @override
  late final GeneratedColumn<int> quantityAvailable = GeneratedColumn<int>(
    'quantity_available',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemType,
    name,
    description,
    price,
    quantityAvailable,
    createdAt,
    updatedAt,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('quantity_available')) {
      context.handle(
        _quantityAvailableMeta,
        quantityAvailable.isAcceptableOrUnknown(
          data['quantity_available']!,
          _quantityAvailableMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      quantityAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_available'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }
}

class InventoryItemRow extends DataClass
    implements Insertable<InventoryItemRow> {
  final String id;

  /// One of: part, oil, service
  final String itemType;
  final String name;
  final String? description;
  final double price;
  final int quantityAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  const InventoryItemRow({
    required this.id,
    required this.itemType,
    required this.name,
    this.description,
    required this.price,
    required this.quantityAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_type'] = Variable<String>(itemType);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price'] = Variable<double>(price);
    map['quantity_available'] = Variable<int>(quantityAvailable);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      itemType: Value(itemType),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      price: Value(price),
      quantityAvailable: Value(quantityAvailable),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory InventoryItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItemRow(
      id: serializer.fromJson<String>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<double>(json['price']),
      quantityAvailable: serializer.fromJson<int>(json['quantityAvailable']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemType': serializer.toJson<String>(itemType),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<double>(price),
      'quantityAvailable': serializer.toJson<int>(quantityAvailable),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  InventoryItemRow copyWith({
    String? id,
    String? itemType,
    String? name,
    Value<String?> description = const Value.absent(),
    double? price,
    int? quantityAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) => InventoryItemRow(
    id: id ?? this.id,
    itemType: itemType ?? this.itemType,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    price: price ?? this.price,
    quantityAvailable: quantityAvailable ?? this.quantityAvailable,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
  );
  InventoryItemRow copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItemRow(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      price: data.price.present ? data.price.value : this.price,
      quantityAvailable: data.quantityAvailable.present
          ? data.quantityAvailable.value
          : this.quantityAvailable,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemRow(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('quantityAvailable: $quantityAvailable, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemType,
    name,
    description,
    price,
    quantityAvailable,
    createdAt,
    updatedAt,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItemRow &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.quantityAvailable == this.quantityAvailable &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItemRow> {
  final Value<String> id;
  final Value<String> itemType;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> price;
  final Value<int> quantityAvailable;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.quantityAvailable = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    required String id,
    required String itemType,
    required String name,
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.quantityAvailable = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemType = Value(itemType),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InventoryItemRow> custom({
    Expression<String>? id,
    Expression<String>? itemType,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? price,
    Expression<int>? quantityAvailable,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'item_type': itemType,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (quantityAvailable != null) 'quantity_available': quantityAvailable,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? itemType,
    Value<String>? name,
    Value<String?>? description,
    Value<double>? price,
    Value<int>? quantityAvailable,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantityAvailable.present) {
      map['quantity_available'] = Variable<int>(quantityAvailable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('quantityAvailable: $quantityAvailable, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceLogsTable extends MaintenanceLogs
    with TableInfo<$MaintenanceLogsTable, MaintenanceLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 2000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, vehicleId, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MaintenanceLogsTable createAlias(String alias) {
    return $MaintenanceLogsTable(attachedDatabase, alias);
  }
}

class MaintenanceLogRow extends DataClass
    implements Insertable<MaintenanceLogRow> {
  final String id;
  final String vehicleId;
  final String note;
  final DateTime createdAt;
  const MaintenanceLogRow({
    required this.id,
    required this.vehicleId,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MaintenanceLogsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceLogsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory MaintenanceLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceLogRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MaintenanceLogRow copyWith({
    String? id,
    String? vehicleId,
    String? note,
    DateTime? createdAt,
  }) => MaintenanceLogRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  MaintenanceLogRow copyWithCompanion(MaintenanceLogsCompanion data) {
    return MaintenanceLogRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLogRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vehicleId, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceLogRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class MaintenanceLogsCompanion extends UpdateCompanion<MaintenanceLogRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MaintenanceLogsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceLogsCompanion.insert({
    required String id,
    required String vehicleId,
    required String note,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       note = Value(note),
       createdAt = Value(createdAt);
  static Insertable<MaintenanceLogRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MaintenanceLogsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLogsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionMeta = const VerificationMeta(
    'collection',
  );
  @override
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
    'collection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collection,
    documentId,
    operation,
    payloadJson,
    createdAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('collection')) {
      context.handle(
        _collectionMeta,
        collection.isAcceptableOrUnknown(data['collection']!, _collectionMeta),
      );
    } else if (isInserting) {
      context.missing(_collectionMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      collection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxRow extends DataClass implements Insertable<SyncOutboxRow> {
  final String id;

  /// Collection name, e.g. customers, vehicles.
  final String collection;

  /// Document id within the collection.
  final String documentId;

  /// upsert | delete
  final String operation;

  /// JSON payload for upsert (null for delete).
  final String? payloadJson;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;
  const SyncOutboxRow({
    required this.id,
    required this.collection,
    required this.documentId,
    required this.operation,
    this.payloadJson,
    required this.createdAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['collection'] = Variable<String>(collection);
    map['document_id'] = Variable<String>(documentId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      collection: Value(collection),
      documentId: Value(documentId),
      operation: Value(operation),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncOutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxRow(
      id: serializer.fromJson<String>(json['id']),
      collection: serializer.fromJson<String>(json['collection']),
      documentId: serializer.fromJson<String>(json['documentId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'collection': serializer.toJson<String>(collection),
      'documentId': serializer.toJson<String>(documentId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String?>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncOutboxRow copyWith({
    String? id,
    String? collection,
    String? documentId,
    String? operation,
    Value<String?> payloadJson = const Value.absent(),
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => SyncOutboxRow(
    id: id ?? this.id,
    collection: collection ?? this.collection,
    documentId: documentId ?? this.documentId,
    operation: operation ?? this.operation,
    payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  SyncOutboxRow copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxRow(
      id: data.id.present ? data.id.value : this.id,
      collection: data.collection.present
          ? data.collection.value
          : this.collection,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRow(')
          ..write('id: $id, ')
          ..write('collection: $collection, ')
          ..write('documentId: $documentId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collection,
    documentId,
    operation,
    payloadJson,
    createdAt,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxRow &&
          other.id == this.id &&
          other.collection == this.collection &&
          other.documentId == this.documentId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxRow> {
  final Value<String> id;
  final Value<String> collection;
  final Value<String> documentId;
  final Value<String> operation;
  final Value<String?> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.collection = const Value.absent(),
    this.documentId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String collection,
    required String documentId,
    required String operation,
    this.payloadJson = const Value.absent(),
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       collection = Value(collection),
       documentId = Value(documentId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxRow> custom({
    Expression<String>? id,
    Expression<String>? collection,
    Expression<String>? documentId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collection != null) 'collection': collection,
      if (documentId != null) 'document_id': documentId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? collection,
    Value<String>? documentId,
    Value<String>? operation,
    Value<String?>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      collection: collection ?? this.collection,
      documentId: documentId ?? this.documentId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (collection.present) {
      map['collection'] = Variable<String>(collection.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('collection: $collection, ')
          ..write('documentId: $documentId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaRow extends DataClass implements Insertable<SyncMetaRow> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const SyncMetaRow({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncMetaRow copyWith({String? key, String? value, DateTime? updatedAt}) =>
      SyncMetaRow(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncMetaRow copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaRow &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<SyncMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(UserProfileSchema.version),
  );
  static const VerificationMeta _accountStatusMeta = const VerificationMeta(
    'accountStatus',
  );
  @override
  late final GeneratedColumn<String> accountStatus = GeneratedColumn<String>(
    'account_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(AccountStatus.active),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Owner'),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workshopNameMeta = const VerificationMeta(
    'workshopName',
  );
  @override
  late final GeneratedColumn<String> workshopName = GeneratedColumn<String>(
    'workshop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Muzammil Autos'),
  );
  static const VerificationMeta _workshopTaglineMeta = const VerificationMeta(
    'workshopTagline',
  );
  @override
  late final GeneratedColumn<String> workshopTagline = GeneratedColumn<String>(
    'workshop_tagline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workshopAddressMeta = const VerificationMeta(
    'workshopAddress',
  );
  @override
  late final GeneratedColumn<String> workshopAddress = GeneratedColumn<String>(
    'workshop_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workshopPhoneMeta = const VerificationMeta(
    'workshopPhone',
  );
  @override
  late final GeneratedColumn<String> workshopPhone = GeneratedColumn<String>(
    'workshop_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workshopEmailMeta = const VerificationMeta(
    'workshopEmail',
  );
  @override
  late final GeneratedColumn<String> workshopEmail = GeneratedColumn<String>(
    'workshop_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workshopLogoUrlMeta = const VerificationMeta(
    'workshopLogoUrl',
  );
  @override
  late final GeneratedColumn<String> workshopLogoUrl = GeneratedColumn<String>(
    'workshop_logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Asia/Karachi'),
  );
  static const VerificationMeta _invoiceTaxPercentMeta = const VerificationMeta(
    'invoiceTaxPercent',
  );
  @override
  late final GeneratedColumn<double> invoiceTaxPercent =
      GeneratedColumn<double>(
        'invoice_tax_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _invoiceCurrencyMeta = const VerificationMeta(
    'invoiceCurrency',
  );
  @override
  late final GeneratedColumn<String> invoiceCurrency = GeneratedColumn<String>(
    'invoice_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _invoiceCurrencySymbolMeta =
      const VerificationMeta('invoiceCurrencySymbol');
  @override
  late final GeneratedColumn<String> invoiceCurrencySymbol =
      GeneratedColumn<String>(
        'invoice_currency_symbol',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('\$'),
      );
  static const VerificationMeta _invoicePrefixMeta = const VerificationMeta(
    'invoicePrefix',
  );
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
    'invoice_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INV'),
  );
  static const VerificationMeta _invoiceNextNumberMeta = const VerificationMeta(
    'invoiceNextNumber',
  );
  @override
  late final GeneratedColumn<int> invoiceNextNumber = GeneratedColumn<int>(
    'invoice_next_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dailyReminderHourMeta = const VerificationMeta(
    'dailyReminderHour',
  );
  @override
  late final GeneratedColumn<int> dailyReminderHour = GeneratedColumn<int>(
    'daily_reminder_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _dailyReminderMinuteMeta =
      const VerificationMeta('dailyReminderMinute');
  @override
  late final GeneratedColumn<int> dailyReminderMinute = GeneratedColumn<int>(
    'daily_reminder_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _weeklySummaryEnabledMeta =
      const VerificationMeta('weeklySummaryEnabled');
  @override
  late final GeneratedColumn<bool> weeklySummaryEnabled = GeneratedColumn<bool>(
    'weekly_summary_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weekly_summary_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _monthlySummaryEnabledMeta =
      const VerificationMeta('monthlySummaryEnabled');
  @override
  late final GeneratedColumn<bool> monthlySummaryEnabled =
      GeneratedColumn<bool>(
        'monthly_summary_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("monthly_summary_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _whatsappShortcutEnabledMeta =
      const VerificationMeta('whatsappShortcutEnabled');
  @override
  late final GeneratedColumn<bool> whatsappShortcutEnabled =
      GeneratedColumn<bool>(
        'whatsapp_shortcut_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("whatsapp_shortcut_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _defaultMessageTemplateIdMeta =
      const VerificationMeta('defaultMessageTemplateId');
  @override
  late final GeneratedColumn<String> defaultMessageTemplateId =
      GeneratedColumn<String>(
        'default_message_template_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _extraJsonMeta = const VerificationMeta(
    'extraJson',
  );
  @override
  late final GeneratedColumn<String> extraJson = GeneratedColumn<String>(
    'extra_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    schemaVersion,
    accountStatus,
    email,
    displayName,
    phone,
    workshopName,
    workshopTagline,
    workshopAddress,
    workshopPhone,
    workshopEmail,
    workshopLogoUrl,
    countryCode,
    timezone,
    invoiceTaxPercent,
    invoiceCurrency,
    invoiceCurrencySymbol,
    invoicePrefix,
    invoiceNextNumber,
    themeMode,
    language,
    notificationsEnabled,
    dailyReminderHour,
    dailyReminderMinute,
    weeklySummaryEnabled,
    monthlySummaryEnabled,
    whatsappShortcutEnabled,
    defaultMessageTemplateId,
    extraJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    }
    if (data.containsKey('account_status')) {
      context.handle(
        _accountStatusMeta,
        accountStatus.isAcceptableOrUnknown(
          data['account_status']!,
          _accountStatusMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('workshop_name')) {
      context.handle(
        _workshopNameMeta,
        workshopName.isAcceptableOrUnknown(
          data['workshop_name']!,
          _workshopNameMeta,
        ),
      );
    }
    if (data.containsKey('workshop_tagline')) {
      context.handle(
        _workshopTaglineMeta,
        workshopTagline.isAcceptableOrUnknown(
          data['workshop_tagline']!,
          _workshopTaglineMeta,
        ),
      );
    }
    if (data.containsKey('workshop_address')) {
      context.handle(
        _workshopAddressMeta,
        workshopAddress.isAcceptableOrUnknown(
          data['workshop_address']!,
          _workshopAddressMeta,
        ),
      );
    }
    if (data.containsKey('workshop_phone')) {
      context.handle(
        _workshopPhoneMeta,
        workshopPhone.isAcceptableOrUnknown(
          data['workshop_phone']!,
          _workshopPhoneMeta,
        ),
      );
    }
    if (data.containsKey('workshop_email')) {
      context.handle(
        _workshopEmailMeta,
        workshopEmail.isAcceptableOrUnknown(
          data['workshop_email']!,
          _workshopEmailMeta,
        ),
      );
    }
    if (data.containsKey('workshop_logo_url')) {
      context.handle(
        _workshopLogoUrlMeta,
        workshopLogoUrl.isAcceptableOrUnknown(
          data['workshop_logo_url']!,
          _workshopLogoUrlMeta,
        ),
      );
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('invoice_tax_percent')) {
      context.handle(
        _invoiceTaxPercentMeta,
        invoiceTaxPercent.isAcceptableOrUnknown(
          data['invoice_tax_percent']!,
          _invoiceTaxPercentMeta,
        ),
      );
    }
    if (data.containsKey('invoice_currency')) {
      context.handle(
        _invoiceCurrencyMeta,
        invoiceCurrency.isAcceptableOrUnknown(
          data['invoice_currency']!,
          _invoiceCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('invoice_currency_symbol')) {
      context.handle(
        _invoiceCurrencySymbolMeta,
        invoiceCurrencySymbol.isAcceptableOrUnknown(
          data['invoice_currency_symbol']!,
          _invoiceCurrencySymbolMeta,
        ),
      );
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
        _invoicePrefixMeta,
        invoicePrefix.isAcceptableOrUnknown(
          data['invoice_prefix']!,
          _invoicePrefixMeta,
        ),
      );
    }
    if (data.containsKey('invoice_next_number')) {
      context.handle(
        _invoiceNextNumberMeta,
        invoiceNextNumber.isAcceptableOrUnknown(
          data['invoice_next_number']!,
          _invoiceNextNumberMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('daily_reminder_hour')) {
      context.handle(
        _dailyReminderHourMeta,
        dailyReminderHour.isAcceptableOrUnknown(
          data['daily_reminder_hour']!,
          _dailyReminderHourMeta,
        ),
      );
    }
    if (data.containsKey('daily_reminder_minute')) {
      context.handle(
        _dailyReminderMinuteMeta,
        dailyReminderMinute.isAcceptableOrUnknown(
          data['daily_reminder_minute']!,
          _dailyReminderMinuteMeta,
        ),
      );
    }
    if (data.containsKey('weekly_summary_enabled')) {
      context.handle(
        _weeklySummaryEnabledMeta,
        weeklySummaryEnabled.isAcceptableOrUnknown(
          data['weekly_summary_enabled']!,
          _weeklySummaryEnabledMeta,
        ),
      );
    }
    if (data.containsKey('monthly_summary_enabled')) {
      context.handle(
        _monthlySummaryEnabledMeta,
        monthlySummaryEnabled.isAcceptableOrUnknown(
          data['monthly_summary_enabled']!,
          _monthlySummaryEnabledMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_shortcut_enabled')) {
      context.handle(
        _whatsappShortcutEnabledMeta,
        whatsappShortcutEnabled.isAcceptableOrUnknown(
          data['whatsapp_shortcut_enabled']!,
          _whatsappShortcutEnabledMeta,
        ),
      );
    }
    if (data.containsKey('default_message_template_id')) {
      context.handle(
        _defaultMessageTemplateIdMeta,
        defaultMessageTemplateId.isAcceptableOrUnknown(
          data['default_message_template_id']!,
          _defaultMessageTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('extra_json')) {
      context.handle(
        _extraJsonMeta,
        extraJson.isAcceptableOrUnknown(data['extra_json']!, _extraJsonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  UserProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileRow(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      accountStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_status'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      workshopName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_name'],
      )!,
      workshopTagline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_tagline'],
      ),
      workshopAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_address'],
      ),
      workshopPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_phone'],
      ),
      workshopEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_email'],
      ),
      workshopLogoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_logo_url'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      invoiceTaxPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}invoice_tax_percent'],
      )!,
      invoiceCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_currency'],
      )!,
      invoiceCurrencySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_currency_symbol'],
      )!,
      invoicePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_prefix'],
      )!,
      invoiceNextNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_next_number'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      dailyReminderHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_reminder_hour'],
      )!,
      dailyReminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_reminder_minute'],
      )!,
      weeklySummaryEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weekly_summary_enabled'],
      )!,
      monthlySummaryEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}monthly_summary_enabled'],
      )!,
      whatsappShortcutEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}whatsapp_shortcut_enabled'],
      )!,
      defaultMessageTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_message_template_id'],
      ),
      extraJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfileRow extends DataClass implements Insertable<UserProfileRow> {
  final String uid;

  /// Profile document schema version — see [UserProfileSchema.version].
  final int schemaVersion;

  /// active | suspended | pending_setup
  final String accountStatus;
  final String email;
  final String displayName;
  final String? phone;
  final String workshopName;
  final String? workshopTagline;
  final String? workshopAddress;
  final String? workshopPhone;
  final String? workshopEmail;

  /// Remote URL or local asset path for workshop branding.
  final String? workshopLogoUrl;

  /// ISO 3166-1 alpha-2, e.g. PK, US.
  final String? countryCode;

  /// IANA timezone, e.g. Asia/Karachi — used for reminders and reports.
  final String timezone;
  final double invoiceTaxPercent;
  final String invoiceCurrency;
  final String invoiceCurrencySymbol;
  final String invoicePrefix;
  final int invoiceNextNumber;

  /// light | dark | system
  final String themeMode;
  final String language;
  final bool notificationsEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool weeklySummaryEnabled;
  final bool monthlySummaryEnabled;
  final bool whatsappShortcutEnabled;
  final String? defaultMessageTemplateId;

  /// Forward-compatible JSON blob for fields not yet in the typed schema.
  final String? extraJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfileRow({
    required this.uid,
    required this.schemaVersion,
    required this.accountStatus,
    required this.email,
    required this.displayName,
    this.phone,
    required this.workshopName,
    this.workshopTagline,
    this.workshopAddress,
    this.workshopPhone,
    this.workshopEmail,
    this.workshopLogoUrl,
    this.countryCode,
    required this.timezone,
    required this.invoiceTaxPercent,
    required this.invoiceCurrency,
    required this.invoiceCurrencySymbol,
    required this.invoicePrefix,
    required this.invoiceNextNumber,
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
    required this.dailyReminderHour,
    required this.dailyReminderMinute,
    required this.weeklySummaryEnabled,
    required this.monthlySummaryEnabled,
    required this.whatsappShortcutEnabled,
    this.defaultMessageTemplateId,
    this.extraJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['account_status'] = Variable<String>(accountStatus);
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['workshop_name'] = Variable<String>(workshopName);
    if (!nullToAbsent || workshopTagline != null) {
      map['workshop_tagline'] = Variable<String>(workshopTagline);
    }
    if (!nullToAbsent || workshopAddress != null) {
      map['workshop_address'] = Variable<String>(workshopAddress);
    }
    if (!nullToAbsent || workshopPhone != null) {
      map['workshop_phone'] = Variable<String>(workshopPhone);
    }
    if (!nullToAbsent || workshopEmail != null) {
      map['workshop_email'] = Variable<String>(workshopEmail);
    }
    if (!nullToAbsent || workshopLogoUrl != null) {
      map['workshop_logo_url'] = Variable<String>(workshopLogoUrl);
    }
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    map['timezone'] = Variable<String>(timezone);
    map['invoice_tax_percent'] = Variable<double>(invoiceTaxPercent);
    map['invoice_currency'] = Variable<String>(invoiceCurrency);
    map['invoice_currency_symbol'] = Variable<String>(invoiceCurrencySymbol);
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['invoice_next_number'] = Variable<int>(invoiceNextNumber);
    map['theme_mode'] = Variable<String>(themeMode);
    map['language'] = Variable<String>(language);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['daily_reminder_hour'] = Variable<int>(dailyReminderHour);
    map['daily_reminder_minute'] = Variable<int>(dailyReminderMinute);
    map['weekly_summary_enabled'] = Variable<bool>(weeklySummaryEnabled);
    map['monthly_summary_enabled'] = Variable<bool>(monthlySummaryEnabled);
    map['whatsapp_shortcut_enabled'] = Variable<bool>(whatsappShortcutEnabled);
    if (!nullToAbsent || defaultMessageTemplateId != null) {
      map['default_message_template_id'] = Variable<String>(
        defaultMessageTemplateId,
      );
    }
    if (!nullToAbsent || extraJson != null) {
      map['extra_json'] = Variable<String>(extraJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      uid: Value(uid),
      schemaVersion: Value(schemaVersion),
      accountStatus: Value(accountStatus),
      email: Value(email),
      displayName: Value(displayName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      workshopName: Value(workshopName),
      workshopTagline: workshopTagline == null && nullToAbsent
          ? const Value.absent()
          : Value(workshopTagline),
      workshopAddress: workshopAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(workshopAddress),
      workshopPhone: workshopPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(workshopPhone),
      workshopEmail: workshopEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(workshopEmail),
      workshopLogoUrl: workshopLogoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(workshopLogoUrl),
      countryCode: countryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(countryCode),
      timezone: Value(timezone),
      invoiceTaxPercent: Value(invoiceTaxPercent),
      invoiceCurrency: Value(invoiceCurrency),
      invoiceCurrencySymbol: Value(invoiceCurrencySymbol),
      invoicePrefix: Value(invoicePrefix),
      invoiceNextNumber: Value(invoiceNextNumber),
      themeMode: Value(themeMode),
      language: Value(language),
      notificationsEnabled: Value(notificationsEnabled),
      dailyReminderHour: Value(dailyReminderHour),
      dailyReminderMinute: Value(dailyReminderMinute),
      weeklySummaryEnabled: Value(weeklySummaryEnabled),
      monthlySummaryEnabled: Value(monthlySummaryEnabled),
      whatsappShortcutEnabled: Value(whatsappShortcutEnabled),
      defaultMessageTemplateId: defaultMessageTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultMessageTemplateId),
      extraJson: extraJson == null && nullToAbsent
          ? const Value.absent()
          : Value(extraJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileRow(
      uid: serializer.fromJson<String>(json['uid']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      accountStatus: serializer.fromJson<String>(json['accountStatus']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      phone: serializer.fromJson<String?>(json['phone']),
      workshopName: serializer.fromJson<String>(json['workshopName']),
      workshopTagline: serializer.fromJson<String?>(json['workshopTagline']),
      workshopAddress: serializer.fromJson<String?>(json['workshopAddress']),
      workshopPhone: serializer.fromJson<String?>(json['workshopPhone']),
      workshopEmail: serializer.fromJson<String?>(json['workshopEmail']),
      workshopLogoUrl: serializer.fromJson<String?>(json['workshopLogoUrl']),
      countryCode: serializer.fromJson<String?>(json['countryCode']),
      timezone: serializer.fromJson<String>(json['timezone']),
      invoiceTaxPercent: serializer.fromJson<double>(json['invoiceTaxPercent']),
      invoiceCurrency: serializer.fromJson<String>(json['invoiceCurrency']),
      invoiceCurrencySymbol: serializer.fromJson<String>(
        json['invoiceCurrencySymbol'],
      ),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      invoiceNextNumber: serializer.fromJson<int>(json['invoiceNextNumber']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      language: serializer.fromJson<String>(json['language']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      dailyReminderHour: serializer.fromJson<int>(json['dailyReminderHour']),
      dailyReminderMinute: serializer.fromJson<int>(
        json['dailyReminderMinute'],
      ),
      weeklySummaryEnabled: serializer.fromJson<bool>(
        json['weeklySummaryEnabled'],
      ),
      monthlySummaryEnabled: serializer.fromJson<bool>(
        json['monthlySummaryEnabled'],
      ),
      whatsappShortcutEnabled: serializer.fromJson<bool>(
        json['whatsappShortcutEnabled'],
      ),
      defaultMessageTemplateId: serializer.fromJson<String?>(
        json['defaultMessageTemplateId'],
      ),
      extraJson: serializer.fromJson<String?>(json['extraJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'accountStatus': serializer.toJson<String>(accountStatus),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'phone': serializer.toJson<String?>(phone),
      'workshopName': serializer.toJson<String>(workshopName),
      'workshopTagline': serializer.toJson<String?>(workshopTagline),
      'workshopAddress': serializer.toJson<String?>(workshopAddress),
      'workshopPhone': serializer.toJson<String?>(workshopPhone),
      'workshopEmail': serializer.toJson<String?>(workshopEmail),
      'workshopLogoUrl': serializer.toJson<String?>(workshopLogoUrl),
      'countryCode': serializer.toJson<String?>(countryCode),
      'timezone': serializer.toJson<String>(timezone),
      'invoiceTaxPercent': serializer.toJson<double>(invoiceTaxPercent),
      'invoiceCurrency': serializer.toJson<String>(invoiceCurrency),
      'invoiceCurrencySymbol': serializer.toJson<String>(invoiceCurrencySymbol),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'invoiceNextNumber': serializer.toJson<int>(invoiceNextNumber),
      'themeMode': serializer.toJson<String>(themeMode),
      'language': serializer.toJson<String>(language),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'dailyReminderHour': serializer.toJson<int>(dailyReminderHour),
      'dailyReminderMinute': serializer.toJson<int>(dailyReminderMinute),
      'weeklySummaryEnabled': serializer.toJson<bool>(weeklySummaryEnabled),
      'monthlySummaryEnabled': serializer.toJson<bool>(monthlySummaryEnabled),
      'whatsappShortcutEnabled': serializer.toJson<bool>(
        whatsappShortcutEnabled,
      ),
      'defaultMessageTemplateId': serializer.toJson<String?>(
        defaultMessageTemplateId,
      ),
      'extraJson': serializer.toJson<String?>(extraJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfileRow copyWith({
    String? uid,
    int? schemaVersion,
    String? accountStatus,
    String? email,
    String? displayName,
    Value<String?> phone = const Value.absent(),
    String? workshopName,
    Value<String?> workshopTagline = const Value.absent(),
    Value<String?> workshopAddress = const Value.absent(),
    Value<String?> workshopPhone = const Value.absent(),
    Value<String?> workshopEmail = const Value.absent(),
    Value<String?> workshopLogoUrl = const Value.absent(),
    Value<String?> countryCode = const Value.absent(),
    String? timezone,
    double? invoiceTaxPercent,
    String? invoiceCurrency,
    String? invoiceCurrencySymbol,
    String? invoicePrefix,
    int? invoiceNextNumber,
    String? themeMode,
    String? language,
    bool? notificationsEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? weeklySummaryEnabled,
    bool? monthlySummaryEnabled,
    bool? whatsappShortcutEnabled,
    Value<String?> defaultMessageTemplateId = const Value.absent(),
    Value<String?> extraJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfileRow(
    uid: uid ?? this.uid,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    accountStatus: accountStatus ?? this.accountStatus,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    phone: phone.present ? phone.value : this.phone,
    workshopName: workshopName ?? this.workshopName,
    workshopTagline: workshopTagline.present
        ? workshopTagline.value
        : this.workshopTagline,
    workshopAddress: workshopAddress.present
        ? workshopAddress.value
        : this.workshopAddress,
    workshopPhone: workshopPhone.present
        ? workshopPhone.value
        : this.workshopPhone,
    workshopEmail: workshopEmail.present
        ? workshopEmail.value
        : this.workshopEmail,
    workshopLogoUrl: workshopLogoUrl.present
        ? workshopLogoUrl.value
        : this.workshopLogoUrl,
    countryCode: countryCode.present ? countryCode.value : this.countryCode,
    timezone: timezone ?? this.timezone,
    invoiceTaxPercent: invoiceTaxPercent ?? this.invoiceTaxPercent,
    invoiceCurrency: invoiceCurrency ?? this.invoiceCurrency,
    invoiceCurrencySymbol: invoiceCurrencySymbol ?? this.invoiceCurrencySymbol,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    invoiceNextNumber: invoiceNextNumber ?? this.invoiceNextNumber,
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
    dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
    weeklySummaryEnabled: weeklySummaryEnabled ?? this.weeklySummaryEnabled,
    monthlySummaryEnabled: monthlySummaryEnabled ?? this.monthlySummaryEnabled,
    whatsappShortcutEnabled:
        whatsappShortcutEnabled ?? this.whatsappShortcutEnabled,
    defaultMessageTemplateId: defaultMessageTemplateId.present
        ? defaultMessageTemplateId.value
        : this.defaultMessageTemplateId,
    extraJson: extraJson.present ? extraJson.value : this.extraJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfileRow copyWithCompanion(UserProfilesCompanion data) {
    return UserProfileRow(
      uid: data.uid.present ? data.uid.value : this.uid,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      accountStatus: data.accountStatus.present
          ? data.accountStatus.value
          : this.accountStatus,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      phone: data.phone.present ? data.phone.value : this.phone,
      workshopName: data.workshopName.present
          ? data.workshopName.value
          : this.workshopName,
      workshopTagline: data.workshopTagline.present
          ? data.workshopTagline.value
          : this.workshopTagline,
      workshopAddress: data.workshopAddress.present
          ? data.workshopAddress.value
          : this.workshopAddress,
      workshopPhone: data.workshopPhone.present
          ? data.workshopPhone.value
          : this.workshopPhone,
      workshopEmail: data.workshopEmail.present
          ? data.workshopEmail.value
          : this.workshopEmail,
      workshopLogoUrl: data.workshopLogoUrl.present
          ? data.workshopLogoUrl.value
          : this.workshopLogoUrl,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      invoiceTaxPercent: data.invoiceTaxPercent.present
          ? data.invoiceTaxPercent.value
          : this.invoiceTaxPercent,
      invoiceCurrency: data.invoiceCurrency.present
          ? data.invoiceCurrency.value
          : this.invoiceCurrency,
      invoiceCurrencySymbol: data.invoiceCurrencySymbol.present
          ? data.invoiceCurrencySymbol.value
          : this.invoiceCurrencySymbol,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      invoiceNextNumber: data.invoiceNextNumber.present
          ? data.invoiceNextNumber.value
          : this.invoiceNextNumber,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      language: data.language.present ? data.language.value : this.language,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      dailyReminderHour: data.dailyReminderHour.present
          ? data.dailyReminderHour.value
          : this.dailyReminderHour,
      dailyReminderMinute: data.dailyReminderMinute.present
          ? data.dailyReminderMinute.value
          : this.dailyReminderMinute,
      weeklySummaryEnabled: data.weeklySummaryEnabled.present
          ? data.weeklySummaryEnabled.value
          : this.weeklySummaryEnabled,
      monthlySummaryEnabled: data.monthlySummaryEnabled.present
          ? data.monthlySummaryEnabled.value
          : this.monthlySummaryEnabled,
      whatsappShortcutEnabled: data.whatsappShortcutEnabled.present
          ? data.whatsappShortcutEnabled.value
          : this.whatsappShortcutEnabled,
      defaultMessageTemplateId: data.defaultMessageTemplateId.present
          ? data.defaultMessageTemplateId.value
          : this.defaultMessageTemplateId,
      extraJson: data.extraJson.present ? data.extraJson.value : this.extraJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileRow(')
          ..write('uid: $uid, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('accountStatus: $accountStatus, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('phone: $phone, ')
          ..write('workshopName: $workshopName, ')
          ..write('workshopTagline: $workshopTagline, ')
          ..write('workshopAddress: $workshopAddress, ')
          ..write('workshopPhone: $workshopPhone, ')
          ..write('workshopEmail: $workshopEmail, ')
          ..write('workshopLogoUrl: $workshopLogoUrl, ')
          ..write('countryCode: $countryCode, ')
          ..write('timezone: $timezone, ')
          ..write('invoiceTaxPercent: $invoiceTaxPercent, ')
          ..write('invoiceCurrency: $invoiceCurrency, ')
          ..write('invoiceCurrencySymbol: $invoiceCurrencySymbol, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceNextNumber: $invoiceNextNumber, ')
          ..write('themeMode: $themeMode, ')
          ..write('language: $language, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('dailyReminderHour: $dailyReminderHour, ')
          ..write('dailyReminderMinute: $dailyReminderMinute, ')
          ..write('weeklySummaryEnabled: $weeklySummaryEnabled, ')
          ..write('monthlySummaryEnabled: $monthlySummaryEnabled, ')
          ..write('whatsappShortcutEnabled: $whatsappShortcutEnabled, ')
          ..write('defaultMessageTemplateId: $defaultMessageTemplateId, ')
          ..write('extraJson: $extraJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    uid,
    schemaVersion,
    accountStatus,
    email,
    displayName,
    phone,
    workshopName,
    workshopTagline,
    workshopAddress,
    workshopPhone,
    workshopEmail,
    workshopLogoUrl,
    countryCode,
    timezone,
    invoiceTaxPercent,
    invoiceCurrency,
    invoiceCurrencySymbol,
    invoicePrefix,
    invoiceNextNumber,
    themeMode,
    language,
    notificationsEnabled,
    dailyReminderHour,
    dailyReminderMinute,
    weeklySummaryEnabled,
    monthlySummaryEnabled,
    whatsappShortcutEnabled,
    defaultMessageTemplateId,
    extraJson,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileRow &&
          other.uid == this.uid &&
          other.schemaVersion == this.schemaVersion &&
          other.accountStatus == this.accountStatus &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.phone == this.phone &&
          other.workshopName == this.workshopName &&
          other.workshopTagline == this.workshopTagline &&
          other.workshopAddress == this.workshopAddress &&
          other.workshopPhone == this.workshopPhone &&
          other.workshopEmail == this.workshopEmail &&
          other.workshopLogoUrl == this.workshopLogoUrl &&
          other.countryCode == this.countryCode &&
          other.timezone == this.timezone &&
          other.invoiceTaxPercent == this.invoiceTaxPercent &&
          other.invoiceCurrency == this.invoiceCurrency &&
          other.invoiceCurrencySymbol == this.invoiceCurrencySymbol &&
          other.invoicePrefix == this.invoicePrefix &&
          other.invoiceNextNumber == this.invoiceNextNumber &&
          other.themeMode == this.themeMode &&
          other.language == this.language &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.dailyReminderHour == this.dailyReminderHour &&
          other.dailyReminderMinute == this.dailyReminderMinute &&
          other.weeklySummaryEnabled == this.weeklySummaryEnabled &&
          other.monthlySummaryEnabled == this.monthlySummaryEnabled &&
          other.whatsappShortcutEnabled == this.whatsappShortcutEnabled &&
          other.defaultMessageTemplateId == this.defaultMessageTemplateId &&
          other.extraJson == this.extraJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfileRow> {
  final Value<String> uid;
  final Value<int> schemaVersion;
  final Value<String> accountStatus;
  final Value<String> email;
  final Value<String> displayName;
  final Value<String?> phone;
  final Value<String> workshopName;
  final Value<String?> workshopTagline;
  final Value<String?> workshopAddress;
  final Value<String?> workshopPhone;
  final Value<String?> workshopEmail;
  final Value<String?> workshopLogoUrl;
  final Value<String?> countryCode;
  final Value<String> timezone;
  final Value<double> invoiceTaxPercent;
  final Value<String> invoiceCurrency;
  final Value<String> invoiceCurrencySymbol;
  final Value<String> invoicePrefix;
  final Value<int> invoiceNextNumber;
  final Value<String> themeMode;
  final Value<String> language;
  final Value<bool> notificationsEnabled;
  final Value<int> dailyReminderHour;
  final Value<int> dailyReminderMinute;
  final Value<bool> weeklySummaryEnabled;
  final Value<bool> monthlySummaryEnabled;
  final Value<bool> whatsappShortcutEnabled;
  final Value<String?> defaultMessageTemplateId;
  final Value<String?> extraJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.uid = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.accountStatus = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.phone = const Value.absent(),
    this.workshopName = const Value.absent(),
    this.workshopTagline = const Value.absent(),
    this.workshopAddress = const Value.absent(),
    this.workshopPhone = const Value.absent(),
    this.workshopEmail = const Value.absent(),
    this.workshopLogoUrl = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.timezone = const Value.absent(),
    this.invoiceTaxPercent = const Value.absent(),
    this.invoiceCurrency = const Value.absent(),
    this.invoiceCurrencySymbol = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceNextNumber = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.language = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.dailyReminderHour = const Value.absent(),
    this.dailyReminderMinute = const Value.absent(),
    this.weeklySummaryEnabled = const Value.absent(),
    this.monthlySummaryEnabled = const Value.absent(),
    this.whatsappShortcutEnabled = const Value.absent(),
    this.defaultMessageTemplateId = const Value.absent(),
    this.extraJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String uid,
    this.schemaVersion = const Value.absent(),
    this.accountStatus = const Value.absent(),
    required String email,
    this.displayName = const Value.absent(),
    this.phone = const Value.absent(),
    this.workshopName = const Value.absent(),
    this.workshopTagline = const Value.absent(),
    this.workshopAddress = const Value.absent(),
    this.workshopPhone = const Value.absent(),
    this.workshopEmail = const Value.absent(),
    this.workshopLogoUrl = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.timezone = const Value.absent(),
    this.invoiceTaxPercent = const Value.absent(),
    this.invoiceCurrency = const Value.absent(),
    this.invoiceCurrencySymbol = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceNextNumber = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.language = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.dailyReminderHour = const Value.absent(),
    this.dailyReminderMinute = const Value.absent(),
    this.weeklySummaryEnabled = const Value.absent(),
    this.monthlySummaryEnabled = const Value.absent(),
    this.whatsappShortcutEnabled = const Value.absent(),
    this.defaultMessageTemplateId = const Value.absent(),
    this.extraJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       email = Value(email),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfileRow> custom({
    Expression<String>? uid,
    Expression<int>? schemaVersion,
    Expression<String>? accountStatus,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? phone,
    Expression<String>? workshopName,
    Expression<String>? workshopTagline,
    Expression<String>? workshopAddress,
    Expression<String>? workshopPhone,
    Expression<String>? workshopEmail,
    Expression<String>? workshopLogoUrl,
    Expression<String>? countryCode,
    Expression<String>? timezone,
    Expression<double>? invoiceTaxPercent,
    Expression<String>? invoiceCurrency,
    Expression<String>? invoiceCurrencySymbol,
    Expression<String>? invoicePrefix,
    Expression<int>? invoiceNextNumber,
    Expression<String>? themeMode,
    Expression<String>? language,
    Expression<bool>? notificationsEnabled,
    Expression<int>? dailyReminderHour,
    Expression<int>? dailyReminderMinute,
    Expression<bool>? weeklySummaryEnabled,
    Expression<bool>? monthlySummaryEnabled,
    Expression<bool>? whatsappShortcutEnabled,
    Expression<String>? defaultMessageTemplateId,
    Expression<String>? extraJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (accountStatus != null) 'account_status': accountStatus,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (phone != null) 'phone': phone,
      if (workshopName != null) 'workshop_name': workshopName,
      if (workshopTagline != null) 'workshop_tagline': workshopTagline,
      if (workshopAddress != null) 'workshop_address': workshopAddress,
      if (workshopPhone != null) 'workshop_phone': workshopPhone,
      if (workshopEmail != null) 'workshop_email': workshopEmail,
      if (workshopLogoUrl != null) 'workshop_logo_url': workshopLogoUrl,
      if (countryCode != null) 'country_code': countryCode,
      if (timezone != null) 'timezone': timezone,
      if (invoiceTaxPercent != null) 'invoice_tax_percent': invoiceTaxPercent,
      if (invoiceCurrency != null) 'invoice_currency': invoiceCurrency,
      if (invoiceCurrencySymbol != null)
        'invoice_currency_symbol': invoiceCurrencySymbol,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (invoiceNextNumber != null) 'invoice_next_number': invoiceNextNumber,
      if (themeMode != null) 'theme_mode': themeMode,
      if (language != null) 'language': language,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (dailyReminderHour != null) 'daily_reminder_hour': dailyReminderHour,
      if (dailyReminderMinute != null)
        'daily_reminder_minute': dailyReminderMinute,
      if (weeklySummaryEnabled != null)
        'weekly_summary_enabled': weeklySummaryEnabled,
      if (monthlySummaryEnabled != null)
        'monthly_summary_enabled': monthlySummaryEnabled,
      if (whatsappShortcutEnabled != null)
        'whatsapp_shortcut_enabled': whatsappShortcutEnabled,
      if (defaultMessageTemplateId != null)
        'default_message_template_id': defaultMessageTemplateId,
      if (extraJson != null) 'extra_json': extraJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? uid,
    Value<int>? schemaVersion,
    Value<String>? accountStatus,
    Value<String>? email,
    Value<String>? displayName,
    Value<String?>? phone,
    Value<String>? workshopName,
    Value<String?>? workshopTagline,
    Value<String?>? workshopAddress,
    Value<String?>? workshopPhone,
    Value<String?>? workshopEmail,
    Value<String?>? workshopLogoUrl,
    Value<String?>? countryCode,
    Value<String>? timezone,
    Value<double>? invoiceTaxPercent,
    Value<String>? invoiceCurrency,
    Value<String>? invoiceCurrencySymbol,
    Value<String>? invoicePrefix,
    Value<int>? invoiceNextNumber,
    Value<String>? themeMode,
    Value<String>? language,
    Value<bool>? notificationsEnabled,
    Value<int>? dailyReminderHour,
    Value<int>? dailyReminderMinute,
    Value<bool>? weeklySummaryEnabled,
    Value<bool>? monthlySummaryEnabled,
    Value<bool>? whatsappShortcutEnabled,
    Value<String?>? defaultMessageTemplateId,
    Value<String?>? extraJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      uid: uid ?? this.uid,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      accountStatus: accountStatus ?? this.accountStatus,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      workshopName: workshopName ?? this.workshopName,
      workshopTagline: workshopTagline ?? this.workshopTagline,
      workshopAddress: workshopAddress ?? this.workshopAddress,
      workshopPhone: workshopPhone ?? this.workshopPhone,
      workshopEmail: workshopEmail ?? this.workshopEmail,
      workshopLogoUrl: workshopLogoUrl ?? this.workshopLogoUrl,
      countryCode: countryCode ?? this.countryCode,
      timezone: timezone ?? this.timezone,
      invoiceTaxPercent: invoiceTaxPercent ?? this.invoiceTaxPercent,
      invoiceCurrency: invoiceCurrency ?? this.invoiceCurrency,
      invoiceCurrencySymbol:
          invoiceCurrencySymbol ?? this.invoiceCurrencySymbol,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceNextNumber: invoiceNextNumber ?? this.invoiceNextNumber,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      weeklySummaryEnabled: weeklySummaryEnabled ?? this.weeklySummaryEnabled,
      monthlySummaryEnabled:
          monthlySummaryEnabled ?? this.monthlySummaryEnabled,
      whatsappShortcutEnabled:
          whatsappShortcutEnabled ?? this.whatsappShortcutEnabled,
      defaultMessageTemplateId:
          defaultMessageTemplateId ?? this.defaultMessageTemplateId,
      extraJson: extraJson ?? this.extraJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (accountStatus.present) {
      map['account_status'] = Variable<String>(accountStatus.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (workshopName.present) {
      map['workshop_name'] = Variable<String>(workshopName.value);
    }
    if (workshopTagline.present) {
      map['workshop_tagline'] = Variable<String>(workshopTagline.value);
    }
    if (workshopAddress.present) {
      map['workshop_address'] = Variable<String>(workshopAddress.value);
    }
    if (workshopPhone.present) {
      map['workshop_phone'] = Variable<String>(workshopPhone.value);
    }
    if (workshopEmail.present) {
      map['workshop_email'] = Variable<String>(workshopEmail.value);
    }
    if (workshopLogoUrl.present) {
      map['workshop_logo_url'] = Variable<String>(workshopLogoUrl.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (invoiceTaxPercent.present) {
      map['invoice_tax_percent'] = Variable<double>(invoiceTaxPercent.value);
    }
    if (invoiceCurrency.present) {
      map['invoice_currency'] = Variable<String>(invoiceCurrency.value);
    }
    if (invoiceCurrencySymbol.present) {
      map['invoice_currency_symbol'] = Variable<String>(
        invoiceCurrencySymbol.value,
      );
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (invoiceNextNumber.present) {
      map['invoice_next_number'] = Variable<int>(invoiceNextNumber.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (dailyReminderHour.present) {
      map['daily_reminder_hour'] = Variable<int>(dailyReminderHour.value);
    }
    if (dailyReminderMinute.present) {
      map['daily_reminder_minute'] = Variable<int>(dailyReminderMinute.value);
    }
    if (weeklySummaryEnabled.present) {
      map['weekly_summary_enabled'] = Variable<bool>(
        weeklySummaryEnabled.value,
      );
    }
    if (monthlySummaryEnabled.present) {
      map['monthly_summary_enabled'] = Variable<bool>(
        monthlySummaryEnabled.value,
      );
    }
    if (whatsappShortcutEnabled.present) {
      map['whatsapp_shortcut_enabled'] = Variable<bool>(
        whatsappShortcutEnabled.value,
      );
    }
    if (defaultMessageTemplateId.present) {
      map['default_message_template_id'] = Variable<String>(
        defaultMessageTemplateId.value,
      );
    }
    if (extraJson.present) {
      map['extra_json'] = Variable<String>(extraJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('uid: $uid, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('accountStatus: $accountStatus, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('phone: $phone, ')
          ..write('workshopName: $workshopName, ')
          ..write('workshopTagline: $workshopTagline, ')
          ..write('workshopAddress: $workshopAddress, ')
          ..write('workshopPhone: $workshopPhone, ')
          ..write('workshopEmail: $workshopEmail, ')
          ..write('workshopLogoUrl: $workshopLogoUrl, ')
          ..write('countryCode: $countryCode, ')
          ..write('timezone: $timezone, ')
          ..write('invoiceTaxPercent: $invoiceTaxPercent, ')
          ..write('invoiceCurrency: $invoiceCurrency, ')
          ..write('invoiceCurrencySymbol: $invoiceCurrencySymbol, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceNextNumber: $invoiceNextNumber, ')
          ..write('themeMode: $themeMode, ')
          ..write('language: $language, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('dailyReminderHour: $dailyReminderHour, ')
          ..write('dailyReminderMinute: $dailyReminderMinute, ')
          ..write('weeklySummaryEnabled: $weeklySummaryEnabled, ')
          ..write('monthlySummaryEnabled: $monthlySummaryEnabled, ')
          ..write('whatsappShortcutEnabled: $whatsappShortcutEnabled, ')
          ..write('defaultMessageTemplateId: $defaultMessageTemplateId, ')
          ..write('extraJson: $extraJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $ServiceRecordsTable serviceRecords = $ServiceRecordsTable(this);
  late final $MaintenanceRemindersTable maintenanceReminders =
      $MaintenanceRemindersTable(this);
  late final $MessageTemplatesTable messageTemplates = $MessageTemplatesTable(
    this,
  );
  late final $ReminderHistoryTable reminderHistory = $ReminderHistoryTable(
    this,
  );
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $MaintenanceLogsTable maintenanceLogs = $MaintenanceLogsTable(
    this,
  );
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final Index idxCustomersPhone = Index(
    'idx_customers_phone',
    'CREATE INDEX idx_customers_phone ON customers (phone_number)',
  );
  late final Index idxCustomersFullName = Index(
    'idx_customers_full_name',
    'CREATE INDEX idx_customers_full_name ON customers (full_name)',
  );
  late final Index idxVehiclesCustomerId = Index(
    'idx_vehicles_customer_id',
    'CREATE INDEX idx_vehicles_customer_id ON vehicles (customer_id)',
  );
  late final Index idxVehiclesRegistration = Index(
    'idx_vehicles_registration',
    'CREATE INDEX idx_vehicles_registration ON vehicles (registration_number)',
  );
  late final Index idxVehiclesMake = Index(
    'idx_vehicles_make',
    'CREATE INDEX idx_vehicles_make ON vehicles (make)',
  );
  late final Index idxServiceRecordsVehicle = Index(
    'idx_service_records_vehicle',
    'CREATE INDEX idx_service_records_vehicle ON service_records (vehicle_id)',
  );
  late final Index idxServiceRecordsDate = Index(
    'idx_service_records_date',
    'CREATE INDEX idx_service_records_date ON service_records (service_date)',
  );
  late final Index idxRemindersVehicle = Index(
    'idx_reminders_vehicle',
    'CREATE INDEX idx_reminders_vehicle ON maintenance_reminders (vehicle_id)',
  );
  late final Index idxRemindersService = Index(
    'idx_reminders_service',
    'CREATE INDEX idx_reminders_service ON maintenance_reminders (service_record_id)',
  );
  late final Index idxRemindersStatus = Index(
    'idx_reminders_status',
    'CREATE INDEX idx_reminders_status ON maintenance_reminders (status)',
  );
  late final Index idxRemindersNextDate = Index(
    'idx_reminders_next_date',
    'CREATE INDEX idx_reminders_next_date ON maintenance_reminders (next_service_date)',
  );
  late final Index idxReminderHistoryReminder = Index(
    'idx_reminder_history_reminder',
    'CREATE INDEX idx_reminder_history_reminder ON reminder_history (reminder_id)',
  );
  late final Index idxReminderHistoryCreated = Index(
    'idx_reminder_history_created',
    'CREATE INDEX idx_reminder_history_created ON reminder_history (created_at)',
  );
  late final Index idxInvoicesNumber = Index(
    'idx_invoices_number',
    'CREATE INDEX idx_invoices_number ON invoices (invoice_number)',
  );
  late final Index idxInvoicesDate = Index(
    'idx_invoices_date',
    'CREATE INDEX idx_invoices_date ON invoices (invoice_date)',
  );
  late final Index idxInvoicesCustomer = Index(
    'idx_invoices_customer',
    'CREATE INDEX idx_invoices_customer ON invoices (customer_id)',
  );
  late final Index idxInventoryType = Index(
    'idx_inventory_type',
    'CREATE INDEX idx_inventory_type ON inventory_items (item_type)',
  );
  late final Index idxInventoryName = Index(
    'idx_inventory_name',
    'CREATE INDEX idx_inventory_name ON inventory_items (name)',
  );
  late final Index idxMaintenanceLogsVehicle = Index(
    'idx_maintenance_logs_vehicle',
    'CREATE INDEX idx_maintenance_logs_vehicle ON maintenance_logs (vehicle_id)',
  );
  late final Index idxSyncOutboxCreated = Index(
    'idx_sync_outbox_created',
    'CREATE INDEX idx_sync_outbox_created ON sync_outbox (created_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    customers,
    vehicles,
    serviceRecords,
    maintenanceReminders,
    messageTemplates,
    reminderHistory,
    invoices,
    inventoryItems,
    maintenanceLogs,
    syncOutbox,
    syncMeta,
    userProfiles,
    idxCustomersPhone,
    idxCustomersFullName,
    idxVehiclesCustomerId,
    idxVehiclesRegistration,
    idxVehiclesMake,
    idxServiceRecordsVehicle,
    idxServiceRecordsDate,
    idxRemindersVehicle,
    idxRemindersService,
    idxRemindersStatus,
    idxRemindersNextDate,
    idxReminderHistoryReminder,
    idxReminderHistoryCreated,
    idxInvoicesNumber,
    idxInvoicesDate,
    idxInvoicesCustomer,
    idxInventoryType,
    idxInventoryName,
    idxMaintenanceLogsVehicle,
    idxSyncOutboxCreated,
  ];
}

typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String fullName,
      required String phoneNumber,
      Value<String?> whatsappNumber,
      Value<String?> email,
      Value<String?> address,
      Value<String?> city,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String> phoneNumber,
      Value<String?> whatsappNumber,
      Value<String?> email,
      Value<String?> address,
      Value<String?> city,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, CustomerRow> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiclesTable, List<VehicleRow>>
  _vehiclesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vehicles,
    aliasName: $_aliasNameGenerator(db.customers.id, db.vehicles.customerId),
  );

  $$VehiclesTableProcessedTableManager get vehiclesRefs {
    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiclesRefs(
    Expression<bool> Function($$VehiclesTableFilterComposer f) f,
  ) {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  Expression<T> vehiclesRefs<T extends Object>(
    Expression<T> Function($$VehiclesTableAnnotationComposer a) f,
  ) {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          CustomerRow,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (CustomerRow, $$CustomersTableReferences),
          CustomerRow,
          PrefetchHooks Function({bool vehiclesRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                fullName: fullName,
                phoneNumber: phoneNumber,
                whatsappNumber: whatsappNumber,
                email: email,
                address: address,
                city: city,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                required String phoneNumber,
                Value<String?> whatsappNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                fullName: fullName,
                phoneNumber: phoneNumber,
                whatsappNumber: whatsappNumber,
                email: email,
                address: address,
                city: city,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehiclesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vehiclesRefs) db.vehicles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vehiclesRefs)
                    await $_getPrefetchedData<
                      CustomerRow,
                      $CustomersTable,
                      VehicleRow
                    >(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._vehiclesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(
                            db,
                            table,
                            p0,
                          ).vehiclesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      CustomerRow,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (CustomerRow, $$CustomersTableReferences),
      CustomerRow,
      PrefetchHooks Function({bool vehiclesRefs})
    >;
typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      required String id,
      required String customerId,
      required String make,
      required String model,
      Value<String?> variant,
      Value<int?> year,
      required String registrationNumber,
      Value<String?> vinNumber,
      Value<String?> engineNumber,
      Value<String?> engineCapacity,
      required String fuelType,
      required String transmission,
      Value<String?> color,
      required int currentOdo,
      Value<DateTime?> purchaseDate,
      Value<DateTime?> insuranceExpiry,
      Value<DateTime?> registrationExpiry,
      Value<String?> imagePath,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> make,
      Value<String> model,
      Value<String?> variant,
      Value<int?> year,
      Value<String> registrationNumber,
      Value<String?> vinNumber,
      Value<String?> engineNumber,
      Value<String?> engineCapacity,
      Value<String> fuelType,
      Value<String> transmission,
      Value<String?> color,
      Value<int> currentOdo,
      Value<DateTime?> purchaseDate,
      Value<DateTime?> insuranceExpiry,
      Value<DateTime?> registrationExpiry,
      Value<String?> imagePath,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, VehicleRow> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias(
        $_aliasNameGenerator(db.vehicles.customerId, db.customers.id),
      );

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ServiceRecordsTable, List<ServiceRecordRow>>
  _serviceRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceRecords,
    aliasName: $_aliasNameGenerator(
      db.vehicles.id,
      db.serviceRecords.vehicleId,
    ),
  );

  $$ServiceRecordsTableProcessedTableManager get serviceRecordsRefs {
    final manager = $$ServiceRecordsTableTableManager(
      $_db,
      $_db.serviceRecords,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MaintenanceRemindersTable,
    List<MaintenanceReminderRow>
  >
  _maintenanceRemindersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceReminders,
        aliasName: $_aliasNameGenerator(
          db.vehicles.id,
          db.maintenanceReminders.vehicleId,
        ),
      );

  $$MaintenanceRemindersTableProcessedTableManager
  get maintenanceRemindersRefs {
    final manager = $$MaintenanceRemindersTableTableManager(
      $_db,
      $_db.maintenanceReminders,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceRemindersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaintenanceLogsTable, List<MaintenanceLogRow>>
  _maintenanceLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.maintenanceLogs,
    aliasName: $_aliasNameGenerator(
      db.vehicles.id,
      db.maintenanceLogs.vehicleId,
    ),
  );

  $$MaintenanceLogsTableProcessedTableManager get maintenanceLogsRefs {
    final manager = $$MaintenanceLogsTableTableManager(
      $_db,
      $_db.maintenanceLogs,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vinNumber => $composableBuilder(
    column: $table.vinNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineNumber => $composableBuilder(
    column: $table.engineNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineCapacity => $composableBuilder(
    column: $table.engineCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transmission => $composableBuilder(
    column: $table.transmission,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentOdo => $composableBuilder(
    column: $table.currentOdo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get insuranceExpiry => $composableBuilder(
    column: $table.insuranceExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registrationExpiry => $composableBuilder(
    column: $table.registrationExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> serviceRecordsRefs(
    Expression<bool> Function($$ServiceRecordsTableFilterComposer f) f,
  ) {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> maintenanceRemindersRefs(
    Expression<bool> Function($$MaintenanceRemindersTableFilterComposer f) f,
  ) {
    final $$MaintenanceRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceReminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceRemindersTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> maintenanceLogsRefs(
    Expression<bool> Function($$MaintenanceLogsTableFilterComposer f) f,
  ) {
    final $$MaintenanceLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceLogsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vinNumber => $composableBuilder(
    column: $table.vinNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineNumber => $composableBuilder(
    column: $table.engineNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineCapacity => $composableBuilder(
    column: $table.engineCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transmission => $composableBuilder(
    column: $table.transmission,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentOdo => $composableBuilder(
    column: $table.currentOdo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get insuranceExpiry => $composableBuilder(
    column: $table.insuranceExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registrationExpiry => $composableBuilder(
    column: $table.registrationExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vinNumber =>
      $composableBuilder(column: $table.vinNumber, builder: (column) => column);

  GeneratedColumn<String> get engineNumber => $composableBuilder(
    column: $table.engineNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get engineCapacity => $composableBuilder(
    column: $table.engineCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<String> get transmission => $composableBuilder(
    column: $table.transmission,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get currentOdo => $composableBuilder(
    column: $table.currentOdo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get insuranceExpiry => $composableBuilder(
    column: $table.insuranceExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get registrationExpiry => $composableBuilder(
    column: $table.registrationExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> serviceRecordsRefs<T extends Object>(
    Expression<T> Function($$ServiceRecordsTableAnnotationComposer a) f,
  ) {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> maintenanceRemindersRefs<T extends Object>(
    Expression<T> Function($$MaintenanceRemindersTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceRemindersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.maintenanceReminders,
          getReferencedColumn: (t) => t.vehicleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceRemindersTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceReminders,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> maintenanceLogsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceLogsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.maintenanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          VehicleRow,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (VehicleRow, $$VehiclesTableReferences),
          VehicleRow,
          PrefetchHooks Function({
            bool customerId,
            bool serviceRecordsRefs,
            bool maintenanceRemindersRefs,
            bool maintenanceLogsRefs,
          })
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> make = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String> registrationNumber = const Value.absent(),
                Value<String?> vinNumber = const Value.absent(),
                Value<String?> engineNumber = const Value.absent(),
                Value<String?> engineCapacity = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<String> transmission = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> currentOdo = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<DateTime?> insuranceExpiry = const Value.absent(),
                Value<DateTime?> registrationExpiry = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                customerId: customerId,
                make: make,
                model: model,
                variant: variant,
                year: year,
                registrationNumber: registrationNumber,
                vinNumber: vinNumber,
                engineNumber: engineNumber,
                engineCapacity: engineCapacity,
                fuelType: fuelType,
                transmission: transmission,
                color: color,
                currentOdo: currentOdo,
                purchaseDate: purchaseDate,
                insuranceExpiry: insuranceExpiry,
                registrationExpiry: registrationExpiry,
                imagePath: imagePath,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required String make,
                required String model,
                Value<String?> variant = const Value.absent(),
                Value<int?> year = const Value.absent(),
                required String registrationNumber,
                Value<String?> vinNumber = const Value.absent(),
                Value<String?> engineNumber = const Value.absent(),
                Value<String?> engineCapacity = const Value.absent(),
                required String fuelType,
                required String transmission,
                Value<String?> color = const Value.absent(),
                required int currentOdo,
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<DateTime?> insuranceExpiry = const Value.absent(),
                Value<DateTime?> registrationExpiry = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                customerId: customerId,
                make: make,
                model: model,
                variant: variant,
                year: year,
                registrationNumber: registrationNumber,
                vinNumber: vinNumber,
                engineNumber: engineNumber,
                engineCapacity: engineCapacity,
                fuelType: fuelType,
                transmission: transmission,
                color: color,
                currentOdo: currentOdo,
                purchaseDate: purchaseDate,
                insuranceExpiry: insuranceExpiry,
                registrationExpiry: registrationExpiry,
                imagePath: imagePath,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                serviceRecordsRefs = false,
                maintenanceRemindersRefs = false,
                maintenanceLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serviceRecordsRefs) db.serviceRecords,
                    if (maintenanceRemindersRefs) db.maintenanceReminders,
                    if (maintenanceLogsRefs) db.maintenanceLogs,
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
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$VehiclesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$VehiclesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serviceRecordsRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          ServiceRecordRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._serviceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (maintenanceRemindersRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          MaintenanceReminderRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenanceRemindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceRemindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (maintenanceLogsRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          MaintenanceLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenanceLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
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

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      VehicleRow,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (VehicleRow, $$VehiclesTableReferences),
      VehicleRow,
      PrefetchHooks Function({
        bool customerId,
        bool serviceRecordsRefs,
        bool maintenanceRemindersRefs,
        bool maintenanceLogsRefs,
      })
    >;
typedef $$ServiceRecordsTableCreateCompanionBuilder =
    ServiceRecordsCompanion Function({
      required String id,
      required String vehicleId,
      required DateTime serviceDate,
      required int odometerReading,
      required String serviceType,
      Value<String?> description,
      Value<String?> oilBrand,
      Value<double> laborCost,
      Value<double> partsCost,
      Value<double> totalCost,
      Value<String?> notes,
      Value<String?> reminderType,
      Value<int?> nextServiceOdometer,
      Value<DateTime?> nextServiceDate,
      Value<bool> reminderEnabled,
      Value<bool> whatsappEnabled,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$ServiceRecordsTableUpdateCompanionBuilder =
    ServiceRecordsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<DateTime> serviceDate,
      Value<int> odometerReading,
      Value<String> serviceType,
      Value<String?> description,
      Value<String?> oilBrand,
      Value<double> laborCost,
      Value<double> partsCost,
      Value<double> totalCost,
      Value<String?> notes,
      Value<String?> reminderType,
      Value<int?> nextServiceOdometer,
      Value<DateTime?> nextServiceDate,
      Value<bool> reminderEnabled,
      Value<bool> whatsappEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });

final class $$ServiceRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ServiceRecordsTable, ServiceRecordRow> {
  $$ServiceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.serviceRecords.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MaintenanceRemindersTable,
    List<MaintenanceReminderRow>
  >
  _maintenanceRemindersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceReminders,
        aliasName: $_aliasNameGenerator(
          db.serviceRecords.id,
          db.maintenanceReminders.serviceRecordId,
        ),
      );

  $$MaintenanceRemindersTableProcessedTableManager
  get maintenanceRemindersRefs {
    final manager =
        $$MaintenanceRemindersTableTableManager(
          $_db,
          $_db.maintenanceReminders,
        ).filter(
          (f) => f.serviceRecordId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _maintenanceRemindersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serviceDate => $composableBuilder(
    column: $table.serviceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometerReading => $composableBuilder(
    column: $table.odometerReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oilBrand => $composableBuilder(
    column: $table.oilBrand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get laborCost => $composableBuilder(
    column: $table.laborCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get partsCost => $composableBuilder(
    column: $table.partsCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextServiceOdometer => $composableBuilder(
    column: $table.nextServiceOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get whatsappEnabled => $composableBuilder(
    column: $table.whatsappEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> maintenanceRemindersRefs(
    Expression<bool> Function($$MaintenanceRemindersTableFilterComposer f) f,
  ) {
    final $$MaintenanceRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceReminders,
      getReferencedColumn: (t) => t.serviceRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceRemindersTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serviceDate => $composableBuilder(
    column: $table.serviceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometerReading => $composableBuilder(
    column: $table.odometerReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oilBrand => $composableBuilder(
    column: $table.oilBrand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get laborCost => $composableBuilder(
    column: $table.laborCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get partsCost => $composableBuilder(
    column: $table.partsCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextServiceOdometer => $composableBuilder(
    column: $table.nextServiceOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get whatsappEnabled => $composableBuilder(
    column: $table.whatsappEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServiceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get serviceDate => $composableBuilder(
    column: $table.serviceDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get odometerReading => $composableBuilder(
    column: $table.odometerReading,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oilBrand =>
      $composableBuilder(column: $table.oilBrand, builder: (column) => column);

  GeneratedColumn<double> get laborCost =>
      $composableBuilder(column: $table.laborCost, builder: (column) => column);

  GeneratedColumn<double> get partsCost =>
      $composableBuilder(column: $table.partsCost, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextServiceOdometer => $composableBuilder(
    column: $table.nextServiceOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get whatsappEnabled => $composableBuilder(
    column: $table.whatsappEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> maintenanceRemindersRefs<T extends Object>(
    Expression<T> Function($$MaintenanceRemindersTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceRemindersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.maintenanceReminders,
          getReferencedColumn: (t) => t.serviceRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceRemindersTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceReminders,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ServiceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceRecordsTable,
          ServiceRecordRow,
          $$ServiceRecordsTableFilterComposer,
          $$ServiceRecordsTableOrderingComposer,
          $$ServiceRecordsTableAnnotationComposer,
          $$ServiceRecordsTableCreateCompanionBuilder,
          $$ServiceRecordsTableUpdateCompanionBuilder,
          (ServiceRecordRow, $$ServiceRecordsTableReferences),
          ServiceRecordRow,
          PrefetchHooks Function({
            bool vehicleId,
            bool maintenanceRemindersRefs,
          })
        > {
  $$ServiceRecordsTableTableManager(
    _$AppDatabase db,
    $ServiceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<DateTime> serviceDate = const Value.absent(),
                Value<int> odometerReading = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> oilBrand = const Value.absent(),
                Value<double> laborCost = const Value.absent(),
                Value<double> partsCost = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> reminderType = const Value.absent(),
                Value<int?> nextServiceOdometer = const Value.absent(),
                Value<DateTime?> nextServiceDate = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<bool> whatsappEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceRecordsCompanion(
                id: id,
                vehicleId: vehicleId,
                serviceDate: serviceDate,
                odometerReading: odometerReading,
                serviceType: serviceType,
                description: description,
                oilBrand: oilBrand,
                laborCost: laborCost,
                partsCost: partsCost,
                totalCost: totalCost,
                notes: notes,
                reminderType: reminderType,
                nextServiceOdometer: nextServiceOdometer,
                nextServiceDate: nextServiceDate,
                reminderEnabled: reminderEnabled,
                whatsappEnabled: whatsappEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required DateTime serviceDate,
                required int odometerReading,
                required String serviceType,
                Value<String?> description = const Value.absent(),
                Value<String?> oilBrand = const Value.absent(),
                Value<double> laborCost = const Value.absent(),
                Value<double> partsCost = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> reminderType = const Value.absent(),
                Value<int?> nextServiceOdometer = const Value.absent(),
                Value<DateTime?> nextServiceDate = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<bool> whatsappEnabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceRecordsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                serviceDate: serviceDate,
                odometerReading: odometerReading,
                serviceType: serviceType,
                description: description,
                oilBrand: oilBrand,
                laborCost: laborCost,
                partsCost: partsCost,
                totalCost: totalCost,
                notes: notes,
                reminderType: reminderType,
                nextServiceOdometer: nextServiceOdometer,
                nextServiceDate: nextServiceDate,
                reminderEnabled: reminderEnabled,
                whatsappEnabled: whatsappEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, maintenanceRemindersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (maintenanceRemindersRefs) db.maintenanceReminders,
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
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable:
                                        $$ServiceRecordsTableReferences
                                            ._vehicleIdTable(db),
                                    referencedColumn:
                                        $$ServiceRecordsTableReferences
                                            ._vehicleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (maintenanceRemindersRefs)
                        await $_getPrefetchedData<
                          ServiceRecordRow,
                          $ServiceRecordsTable,
                          MaintenanceReminderRow
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceRecordsTableReferences
                              ._maintenanceRemindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceRemindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serviceRecordId == item.id,
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

typedef $$ServiceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceRecordsTable,
      ServiceRecordRow,
      $$ServiceRecordsTableFilterComposer,
      $$ServiceRecordsTableOrderingComposer,
      $$ServiceRecordsTableAnnotationComposer,
      $$ServiceRecordsTableCreateCompanionBuilder,
      $$ServiceRecordsTableUpdateCompanionBuilder,
      (ServiceRecordRow, $$ServiceRecordsTableReferences),
      ServiceRecordRow,
      PrefetchHooks Function({bool vehicleId, bool maintenanceRemindersRefs})
    >;
typedef $$MaintenanceRemindersTableCreateCompanionBuilder =
    MaintenanceRemindersCompanion Function({
      required String id,
      required String vehicleId,
      required String serviceRecordId,
      required int currentOdometer,
      Value<int?> nextServiceOdometer,
      required DateTime lastServiceDate,
      Value<DateTime?> nextServiceDate,
      required String reminderType,
      required String status,
      Value<DateTime?> lastReminderSent,
      Value<bool> notificationEnabled,
      Value<bool> whatsappEnabled,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MaintenanceRemindersTableUpdateCompanionBuilder =
    MaintenanceRemindersCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> serviceRecordId,
      Value<int> currentOdometer,
      Value<int?> nextServiceOdometer,
      Value<DateTime> lastServiceDate,
      Value<DateTime?> nextServiceDate,
      Value<String> reminderType,
      Value<String> status,
      Value<DateTime?> lastReminderSent,
      Value<bool> notificationEnabled,
      Value<bool> whatsappEnabled,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MaintenanceRemindersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MaintenanceRemindersTable,
          MaintenanceReminderRow
        > {
  $$MaintenanceRemindersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.maintenanceReminders.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServiceRecordsTable _serviceRecordIdTable(_$AppDatabase db) =>
      db.serviceRecords.createAlias(
        $_aliasNameGenerator(
          db.maintenanceReminders.serviceRecordId,
          db.serviceRecords.id,
        ),
      );

  $$ServiceRecordsTableProcessedTableManager get serviceRecordId {
    final $_column = $_itemColumn<String>('service_record_id')!;

    final manager = $$ServiceRecordsTableTableManager(
      $_db,
      $_db.serviceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaintenanceRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRemindersTable> {
  $$MaintenanceRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextServiceOdometer => $composableBuilder(
    column: $table.nextServiceOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastServiceDate => $composableBuilder(
    column: $table.lastServiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReminderSent => $composableBuilder(
    column: $table.lastReminderSent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get whatsappEnabled => $composableBuilder(
    column: $table.whatsappEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceRecordsTableFilterComposer get serviceRecordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceRecordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRemindersTable> {
  $$MaintenanceRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextServiceOdometer => $composableBuilder(
    column: $table.nextServiceOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastServiceDate => $composableBuilder(
    column: $table.lastServiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReminderSent => $composableBuilder(
    column: $table.lastReminderSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get whatsappEnabled => $composableBuilder(
    column: $table.whatsappEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceRecordsTableOrderingComposer get serviceRecordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceRecordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRemindersTable> {
  $$MaintenanceRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextServiceOdometer => $composableBuilder(
    column: $table.nextServiceOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastServiceDate => $composableBuilder(
    column: $table.lastServiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReminderSent => $composableBuilder(
    column: $table.lastReminderSent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get whatsappEnabled => $composableBuilder(
    column: $table.whatsappEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceRecordsTableAnnotationComposer get serviceRecordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceRecordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceRemindersTable,
          MaintenanceReminderRow,
          $$MaintenanceRemindersTableFilterComposer,
          $$MaintenanceRemindersTableOrderingComposer,
          $$MaintenanceRemindersTableAnnotationComposer,
          $$MaintenanceRemindersTableCreateCompanionBuilder,
          $$MaintenanceRemindersTableUpdateCompanionBuilder,
          (MaintenanceReminderRow, $$MaintenanceRemindersTableReferences),
          MaintenanceReminderRow,
          PrefetchHooks Function({bool vehicleId, bool serviceRecordId})
        > {
  $$MaintenanceRemindersTableTableManager(
    _$AppDatabase db,
    $MaintenanceRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRemindersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MaintenanceRemindersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> serviceRecordId = const Value.absent(),
                Value<int> currentOdometer = const Value.absent(),
                Value<int?> nextServiceOdometer = const Value.absent(),
                Value<DateTime> lastServiceDate = const Value.absent(),
                Value<DateTime?> nextServiceDate = const Value.absent(),
                Value<String> reminderType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> lastReminderSent = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<bool> whatsappEnabled = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceRemindersCompanion(
                id: id,
                vehicleId: vehicleId,
                serviceRecordId: serviceRecordId,
                currentOdometer: currentOdometer,
                nextServiceOdometer: nextServiceOdometer,
                lastServiceDate: lastServiceDate,
                nextServiceDate: nextServiceDate,
                reminderType: reminderType,
                status: status,
                lastReminderSent: lastReminderSent,
                notificationEnabled: notificationEnabled,
                whatsappEnabled: whatsappEnabled,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String serviceRecordId,
                required int currentOdometer,
                Value<int?> nextServiceOdometer = const Value.absent(),
                required DateTime lastServiceDate,
                Value<DateTime?> nextServiceDate = const Value.absent(),
                required String reminderType,
                required String status,
                Value<DateTime?> lastReminderSent = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<bool> whatsappEnabled = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceRemindersCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                serviceRecordId: serviceRecordId,
                currentOdometer: currentOdometer,
                nextServiceOdometer: nextServiceOdometer,
                lastServiceDate: lastServiceDate,
                nextServiceDate: nextServiceDate,
                reminderType: reminderType,
                status: status,
                lastReminderSent: lastReminderSent,
                notificationEnabled: notificationEnabled,
                whatsappEnabled: whatsappEnabled,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaintenanceRemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, serviceRecordId = false}) {
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
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable:
                                        $$MaintenanceRemindersTableReferences
                                            ._vehicleIdTable(db),
                                    referencedColumn:
                                        $$MaintenanceRemindersTableReferences
                                            ._vehicleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (serviceRecordId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.serviceRecordId,
                                    referencedTable:
                                        $$MaintenanceRemindersTableReferences
                                            ._serviceRecordIdTable(db),
                                    referencedColumn:
                                        $$MaintenanceRemindersTableReferences
                                            ._serviceRecordIdTable(db)
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

typedef $$MaintenanceRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceRemindersTable,
      MaintenanceReminderRow,
      $$MaintenanceRemindersTableFilterComposer,
      $$MaintenanceRemindersTableOrderingComposer,
      $$MaintenanceRemindersTableAnnotationComposer,
      $$MaintenanceRemindersTableCreateCompanionBuilder,
      $$MaintenanceRemindersTableUpdateCompanionBuilder,
      (MaintenanceReminderRow, $$MaintenanceRemindersTableReferences),
      MaintenanceReminderRow,
      PrefetchHooks Function({bool vehicleId, bool serviceRecordId})
    >;
typedef $$MessageTemplatesTableCreateCompanionBuilder =
    MessageTemplatesCompanion Function({
      required String id,
      required String name,
      required String body,
      Value<String> category,
      Value<bool> isDefault,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MessageTemplatesTableUpdateCompanionBuilder =
    MessageTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> body,
      Value<String> category,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MessageTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessageTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessageTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MessageTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessageTemplatesTable,
          MessageTemplateRow,
          $$MessageTemplatesTableFilterComposer,
          $$MessageTemplatesTableOrderingComposer,
          $$MessageTemplatesTableAnnotationComposer,
          $$MessageTemplatesTableCreateCompanionBuilder,
          $$MessageTemplatesTableUpdateCompanionBuilder,
          (
            MessageTemplateRow,
            BaseReferences<
              _$AppDatabase,
              $MessageTemplatesTable,
              MessageTemplateRow
            >,
          ),
          MessageTemplateRow,
          PrefetchHooks Function()
        > {
  $$MessageTemplatesTableTableManager(
    _$AppDatabase db,
    $MessageTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageTemplatesCompanion(
                id: id,
                name: name,
                body: body,
                category: category,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String body,
                Value<String> category = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MessageTemplatesCompanion.insert(
                id: id,
                name: name,
                body: body,
                category: category,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessageTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessageTemplatesTable,
      MessageTemplateRow,
      $$MessageTemplatesTableFilterComposer,
      $$MessageTemplatesTableOrderingComposer,
      $$MessageTemplatesTableAnnotationComposer,
      $$MessageTemplatesTableCreateCompanionBuilder,
      $$MessageTemplatesTableUpdateCompanionBuilder,
      (
        MessageTemplateRow,
        BaseReferences<
          _$AppDatabase,
          $MessageTemplatesTable,
          MessageTemplateRow
        >,
      ),
      MessageTemplateRow,
      PrefetchHooks Function()
    >;
typedef $$ReminderHistoryTableCreateCompanionBuilder =
    ReminderHistoryCompanion Function({
      required String id,
      Value<String?> reminderId,
      Value<String?> vehicleId,
      Value<String?> customerId,
      required String actionType,
      Value<String?> title,
      Value<String?> details,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReminderHistoryTableUpdateCompanionBuilder =
    ReminderHistoryCompanion Function({
      Value<String> id,
      Value<String?> reminderId,
      Value<String?> vehicleId,
      Value<String?> customerId,
      Value<String> actionType,
      Value<String?> title,
      Value<String?> details,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ReminderHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderHistoryTable> {
  $$ReminderHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderHistoryTable> {
  $$ReminderHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderHistoryTable> {
  $$ReminderHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReminderHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderHistoryTable,
          ReminderHistoryRow,
          $$ReminderHistoryTableFilterComposer,
          $$ReminderHistoryTableOrderingComposer,
          $$ReminderHistoryTableAnnotationComposer,
          $$ReminderHistoryTableCreateCompanionBuilder,
          $$ReminderHistoryTableUpdateCompanionBuilder,
          (
            ReminderHistoryRow,
            BaseReferences<
              _$AppDatabase,
              $ReminderHistoryTable,
              ReminderHistoryRow
            >,
          ),
          ReminderHistoryRow,
          PrefetchHooks Function()
        > {
  $$ReminderHistoryTableTableManager(
    _$AppDatabase db,
    $ReminderHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> reminderId = const Value.absent(),
                Value<String?> vehicleId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderHistoryCompanion(
                id: id,
                reminderId: reminderId,
                vehicleId: vehicleId,
                customerId: customerId,
                actionType: actionType,
                title: title,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> reminderId = const Value.absent(),
                Value<String?> vehicleId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                required String actionType,
                Value<String?> title = const Value.absent(),
                Value<String?> details = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReminderHistoryCompanion.insert(
                id: id,
                reminderId: reminderId,
                vehicleId: vehicleId,
                customerId: customerId,
                actionType: actionType,
                title: title,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderHistoryTable,
      ReminderHistoryRow,
      $$ReminderHistoryTableFilterComposer,
      $$ReminderHistoryTableOrderingComposer,
      $$ReminderHistoryTableAnnotationComposer,
      $$ReminderHistoryTableCreateCompanionBuilder,
      $$ReminderHistoryTableUpdateCompanionBuilder,
      (
        ReminderHistoryRow,
        BaseReferences<
          _$AppDatabase,
          $ReminderHistoryTable,
          ReminderHistoryRow
        >,
      ),
      ReminderHistoryRow,
      PrefetchHooks Function()
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      required String id,
      Value<String?> serviceRecordId,
      required String customerId,
      required String vehicleId,
      required String invoiceNumber,
      required DateTime invoiceDate,
      Value<double> subtotal,
      Value<double> discount,
      Value<double> tax,
      Value<double> grandTotal,
      Value<String> paymentMethod,
      Value<String> paymentStatus,
      Value<DateTime?> paidDate,
      Value<String> currency,
      Value<String?> notes,
      Value<String?> labourDescription,
      Value<double> labourAmount,
      Value<String?> partsDescription,
      Value<double> partsAmount,
      Value<String?> serviceDescription,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<String> id,
      Value<String?> serviceRecordId,
      Value<String> customerId,
      Value<String> vehicleId,
      Value<String> invoiceNumber,
      Value<DateTime> invoiceDate,
      Value<double> subtotal,
      Value<double> discount,
      Value<double> tax,
      Value<double> grandTotal,
      Value<String> paymentMethod,
      Value<String> paymentStatus,
      Value<DateTime?> paidDate,
      Value<String> currency,
      Value<String?> notes,
      Value<String?> labourDescription,
      Value<double> labourAmount,
      Value<String?> partsDescription,
      Value<double> partsAmount,
      Value<String?> serviceDescription,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceRecordId => $composableBuilder(
    column: $table.serviceRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labourDescription => $composableBuilder(
    column: $table.labourDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get labourAmount => $composableBuilder(
    column: $table.labourAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partsDescription => $composableBuilder(
    column: $table.partsDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get partsAmount => $composableBuilder(
    column: $table.partsAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceDescription => $composableBuilder(
    column: $table.serviceDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceRecordId => $composableBuilder(
    column: $table.serviceRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labourDescription => $composableBuilder(
    column: $table.labourDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get labourAmount => $composableBuilder(
    column: $table.labourAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partsDescription => $composableBuilder(
    column: $table.partsDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get partsAmount => $composableBuilder(
    column: $table.partsAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceDescription => $composableBuilder(
    column: $table.serviceDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceRecordId => $composableBuilder(
    column: $table.serviceRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get labourDescription => $composableBuilder(
    column: $table.labourDescription,
    builder: (column) => column,
  );

  GeneratedColumn<double> get labourAmount => $composableBuilder(
    column: $table.labourAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partsDescription => $composableBuilder(
    column: $table.partsDescription,
    builder: (column) => column,
  );

  GeneratedColumn<double> get partsAmount => $composableBuilder(
    column: $table.partsAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serviceDescription => $composableBuilder(
    column: $table.serviceDescription,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          InvoiceRow,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (
            InvoiceRow,
            BaseReferences<_$AppDatabase, $InvoicesTable, InvoiceRow>,
          ),
          InvoiceRow,
          PrefetchHooks Function()
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serviceRecordId = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<DateTime> invoiceDate = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<double> tax = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> labourDescription = const Value.absent(),
                Value<double> labourAmount = const Value.absent(),
                Value<String?> partsDescription = const Value.absent(),
                Value<double> partsAmount = const Value.absent(),
                Value<String?> serviceDescription = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                serviceRecordId: serviceRecordId,
                customerId: customerId,
                vehicleId: vehicleId,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                paymentStatus: paymentStatus,
                paidDate: paidDate,
                currency: currency,
                notes: notes,
                labourDescription: labourDescription,
                labourAmount: labourAmount,
                partsDescription: partsDescription,
                partsAmount: partsAmount,
                serviceDescription: serviceDescription,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serviceRecordId = const Value.absent(),
                required String customerId,
                required String vehicleId,
                required String invoiceNumber,
                required DateTime invoiceDate,
                Value<double> subtotal = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<double> tax = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> labourDescription = const Value.absent(),
                Value<double> labourAmount = const Value.absent(),
                Value<String?> partsDescription = const Value.absent(),
                Value<double> partsAmount = const Value.absent(),
                Value<String?> serviceDescription = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                serviceRecordId: serviceRecordId,
                customerId: customerId,
                vehicleId: vehicleId,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                paymentStatus: paymentStatus,
                paidDate: paidDate,
                currency: currency,
                notes: notes,
                labourDescription: labourDescription,
                labourAmount: labourAmount,
                partsDescription: partsDescription,
                partsAmount: partsAmount,
                serviceDescription: serviceDescription,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      InvoiceRow,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (InvoiceRow, BaseReferences<_$AppDatabase, $InvoicesTable, InvoiceRow>),
      InvoiceRow,
      PrefetchHooks Function()
    >;
typedef $$InventoryItemsTableCreateCompanionBuilder =
    InventoryItemsCompanion Function({
      required String id,
      required String itemType,
      required String name,
      Value<String?> description,
      Value<double> price,
      Value<int> quantityAvailable,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$InventoryItemsTableUpdateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<String> id,
      Value<String> itemType,
      Value<String> name,
      Value<String?> description,
      Value<double> price,
      Value<int> quantityAvailable,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });

class $$InventoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityAvailable => $composableBuilder(
    column: $table.quantityAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityAvailable => $composableBuilder(
    column: $table.quantityAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantityAvailable => $composableBuilder(
    column: $table.quantityAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );
}

class $$InventoryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryItemsTable,
          InventoryItemRow,
          $$InventoryItemsTableFilterComposer,
          $$InventoryItemsTableOrderingComposer,
          $$InventoryItemsTableAnnotationComposer,
          $$InventoryItemsTableCreateCompanionBuilder,
          $$InventoryItemsTableUpdateCompanionBuilder,
          (
            InventoryItemRow,
            BaseReferences<
              _$AppDatabase,
              $InventoryItemsTable,
              InventoryItemRow
            >,
          ),
          InventoryItemRow,
          PrefetchHooks Function()
        > {
  $$InventoryItemsTableTableManager(
    _$AppDatabase db,
    $InventoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> quantityAvailable = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryItemsCompanion(
                id: id,
                itemType: itemType,
                name: name,
                description: description,
                price: price,
                quantityAvailable: quantityAvailable,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemType,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> quantityAvailable = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryItemsCompanion.insert(
                id: id,
                itemType: itemType,
                name: name,
                description: description,
                price: price,
                quantityAvailable: quantityAvailable,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryItemsTable,
      InventoryItemRow,
      $$InventoryItemsTableFilterComposer,
      $$InventoryItemsTableOrderingComposer,
      $$InventoryItemsTableAnnotationComposer,
      $$InventoryItemsTableCreateCompanionBuilder,
      $$InventoryItemsTableUpdateCompanionBuilder,
      (
        InventoryItemRow,
        BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItemRow>,
      ),
      InventoryItemRow,
      PrefetchHooks Function()
    >;
typedef $$MaintenanceLogsTableCreateCompanionBuilder =
    MaintenanceLogsCompanion Function({
      required String id,
      required String vehicleId,
      required String note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MaintenanceLogsTableUpdateCompanionBuilder =
    MaintenanceLogsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MaintenanceLogsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MaintenanceLogsTable,
          MaintenanceLogRow
        > {
  $$MaintenanceLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.maintenanceLogs.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaintenanceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceLogsTable,
          MaintenanceLogRow,
          $$MaintenanceLogsTableFilterComposer,
          $$MaintenanceLogsTableOrderingComposer,
          $$MaintenanceLogsTableAnnotationComposer,
          $$MaintenanceLogsTableCreateCompanionBuilder,
          $$MaintenanceLogsTableUpdateCompanionBuilder,
          (MaintenanceLogRow, $$MaintenanceLogsTableReferences),
          MaintenanceLogRow,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$MaintenanceLogsTableTableManager(
    _$AppDatabase db,
    $MaintenanceLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceLogsCompanion(
                id: id,
                vehicleId: vehicleId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String note,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceLogsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaintenanceLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
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
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable:
                                    $$MaintenanceLogsTableReferences
                                        ._vehicleIdTable(db),
                                referencedColumn:
                                    $$MaintenanceLogsTableReferences
                                        ._vehicleIdTable(db)
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

typedef $$MaintenanceLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceLogsTable,
      MaintenanceLogRow,
      $$MaintenanceLogsTableFilterComposer,
      $$MaintenanceLogsTableOrderingComposer,
      $$MaintenanceLogsTableAnnotationComposer,
      $$MaintenanceLogsTableCreateCompanionBuilder,
      $$MaintenanceLogsTableUpdateCompanionBuilder,
      (MaintenanceLogRow, $$MaintenanceLogsTableReferences),
      MaintenanceLogRow,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String collection,
      required String documentId,
      required String operation,
      Value<String?> payloadJson,
      required DateTime createdAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> collection,
      Value<String> documentId,
      Value<String> operation,
      Value<String?> payloadJson,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxRow,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxRow,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
          ),
          SyncOutboxRow,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> collection = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                collection: collection,
                documentId: documentId,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String collection,
                required String documentId,
                required String operation,
                Value<String?> payloadJson = const Value.absent(),
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                collection: collection,
                documentId: documentId,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxRow,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxRow,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
      ),
      SyncOutboxRow,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaRow,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaRow,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>,
          ),
          SyncMetaRow,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaRow,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
      SyncMetaRow,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String uid,
      Value<int> schemaVersion,
      Value<String> accountStatus,
      required String email,
      Value<String> displayName,
      Value<String?> phone,
      Value<String> workshopName,
      Value<String?> workshopTagline,
      Value<String?> workshopAddress,
      Value<String?> workshopPhone,
      Value<String?> workshopEmail,
      Value<String?> workshopLogoUrl,
      Value<String?> countryCode,
      Value<String> timezone,
      Value<double> invoiceTaxPercent,
      Value<String> invoiceCurrency,
      Value<String> invoiceCurrencySymbol,
      Value<String> invoicePrefix,
      Value<int> invoiceNextNumber,
      Value<String> themeMode,
      Value<String> language,
      Value<bool> notificationsEnabled,
      Value<int> dailyReminderHour,
      Value<int> dailyReminderMinute,
      Value<bool> weeklySummaryEnabled,
      Value<bool> monthlySummaryEnabled,
      Value<bool> whatsappShortcutEnabled,
      Value<String?> defaultMessageTemplateId,
      Value<String?> extraJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> uid,
      Value<int> schemaVersion,
      Value<String> accountStatus,
      Value<String> email,
      Value<String> displayName,
      Value<String?> phone,
      Value<String> workshopName,
      Value<String?> workshopTagline,
      Value<String?> workshopAddress,
      Value<String?> workshopPhone,
      Value<String?> workshopEmail,
      Value<String?> workshopLogoUrl,
      Value<String?> countryCode,
      Value<String> timezone,
      Value<double> invoiceTaxPercent,
      Value<String> invoiceCurrency,
      Value<String> invoiceCurrencySymbol,
      Value<String> invoicePrefix,
      Value<int> invoiceNextNumber,
      Value<String> themeMode,
      Value<String> language,
      Value<bool> notificationsEnabled,
      Value<int> dailyReminderHour,
      Value<int> dailyReminderMinute,
      Value<bool> weeklySummaryEnabled,
      Value<bool> monthlySummaryEnabled,
      Value<bool> whatsappShortcutEnabled,
      Value<String?> defaultMessageTemplateId,
      Value<String?> extraJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountStatus => $composableBuilder(
    column: $table.accountStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshopName => $composableBuilder(
    column: $table.workshopName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshopTagline => $composableBuilder(
    column: $table.workshopTagline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshopAddress => $composableBuilder(
    column: $table.workshopAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshopPhone => $composableBuilder(
    column: $table.workshopPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshopEmail => $composableBuilder(
    column: $table.workshopEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshopLogoUrl => $composableBuilder(
    column: $table.workshopLogoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get invoiceTaxPercent => $composableBuilder(
    column: $table.invoiceTaxPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceCurrency => $composableBuilder(
    column: $table.invoiceCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceCurrencySymbol => $composableBuilder(
    column: $table.invoiceCurrencySymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invoiceNextNumber => $composableBuilder(
    column: $table.invoiceNextNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyReminderHour => $composableBuilder(
    column: $table.dailyReminderHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyReminderMinute => $composableBuilder(
    column: $table.dailyReminderMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weeklySummaryEnabled => $composableBuilder(
    column: $table.weeklySummaryEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get monthlySummaryEnabled => $composableBuilder(
    column: $table.monthlySummaryEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get whatsappShortcutEnabled => $composableBuilder(
    column: $table.whatsappShortcutEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultMessageTemplateId => $composableBuilder(
    column: $table.defaultMessageTemplateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountStatus => $composableBuilder(
    column: $table.accountStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshopName => $composableBuilder(
    column: $table.workshopName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshopTagline => $composableBuilder(
    column: $table.workshopTagline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshopAddress => $composableBuilder(
    column: $table.workshopAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshopPhone => $composableBuilder(
    column: $table.workshopPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshopEmail => $composableBuilder(
    column: $table.workshopEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshopLogoUrl => $composableBuilder(
    column: $table.workshopLogoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get invoiceTaxPercent => $composableBuilder(
    column: $table.invoiceTaxPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceCurrency => $composableBuilder(
    column: $table.invoiceCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceCurrencySymbol => $composableBuilder(
    column: $table.invoiceCurrencySymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invoiceNextNumber => $composableBuilder(
    column: $table.invoiceNextNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyReminderHour => $composableBuilder(
    column: $table.dailyReminderHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyReminderMinute => $composableBuilder(
    column: $table.dailyReminderMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weeklySummaryEnabled => $composableBuilder(
    column: $table.weeklySummaryEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get monthlySummaryEnabled => $composableBuilder(
    column: $table.monthlySummaryEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get whatsappShortcutEnabled => $composableBuilder(
    column: $table.whatsappShortcutEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultMessageTemplateId => $composableBuilder(
    column: $table.defaultMessageTemplateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountStatus => $composableBuilder(
    column: $table.accountStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get workshopName => $composableBuilder(
    column: $table.workshopName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workshopTagline => $composableBuilder(
    column: $table.workshopTagline,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workshopAddress => $composableBuilder(
    column: $table.workshopAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workshopPhone => $composableBuilder(
    column: $table.workshopPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workshopEmail => $composableBuilder(
    column: $table.workshopEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workshopLogoUrl => $composableBuilder(
    column: $table.workshopLogoUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<double> get invoiceTaxPercent => $composableBuilder(
    column: $table.invoiceTaxPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceCurrency => $composableBuilder(
    column: $table.invoiceCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceCurrencySymbol => $composableBuilder(
    column: $table.invoiceCurrencySymbol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<int> get invoiceNextNumber => $composableBuilder(
    column: $table.invoiceNextNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyReminderHour => $composableBuilder(
    column: $table.dailyReminderHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyReminderMinute => $composableBuilder(
    column: $table.dailyReminderMinute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weeklySummaryEnabled => $composableBuilder(
    column: $table.weeklySummaryEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get monthlySummaryEnabled => $composableBuilder(
    column: $table.monthlySummaryEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get whatsappShortcutEnabled => $composableBuilder(
    column: $table.whatsappShortcutEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultMessageTemplateId => $composableBuilder(
    column: $table.defaultMessageTemplateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extraJson =>
      $composableBuilder(column: $table.extraJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfileRow,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfileRow,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileRow>,
          ),
          UserProfileRow,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<String> accountStatus = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> workshopName = const Value.absent(),
                Value<String?> workshopTagline = const Value.absent(),
                Value<String?> workshopAddress = const Value.absent(),
                Value<String?> workshopPhone = const Value.absent(),
                Value<String?> workshopEmail = const Value.absent(),
                Value<String?> workshopLogoUrl = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<double> invoiceTaxPercent = const Value.absent(),
                Value<String> invoiceCurrency = const Value.absent(),
                Value<String> invoiceCurrencySymbol = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> invoiceNextNumber = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> dailyReminderHour = const Value.absent(),
                Value<int> dailyReminderMinute = const Value.absent(),
                Value<bool> weeklySummaryEnabled = const Value.absent(),
                Value<bool> monthlySummaryEnabled = const Value.absent(),
                Value<bool> whatsappShortcutEnabled = const Value.absent(),
                Value<String?> defaultMessageTemplateId = const Value.absent(),
                Value<String?> extraJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                uid: uid,
                schemaVersion: schemaVersion,
                accountStatus: accountStatus,
                email: email,
                displayName: displayName,
                phone: phone,
                workshopName: workshopName,
                workshopTagline: workshopTagline,
                workshopAddress: workshopAddress,
                workshopPhone: workshopPhone,
                workshopEmail: workshopEmail,
                workshopLogoUrl: workshopLogoUrl,
                countryCode: countryCode,
                timezone: timezone,
                invoiceTaxPercent: invoiceTaxPercent,
                invoiceCurrency: invoiceCurrency,
                invoiceCurrencySymbol: invoiceCurrencySymbol,
                invoicePrefix: invoicePrefix,
                invoiceNextNumber: invoiceNextNumber,
                themeMode: themeMode,
                language: language,
                notificationsEnabled: notificationsEnabled,
                dailyReminderHour: dailyReminderHour,
                dailyReminderMinute: dailyReminderMinute,
                weeklySummaryEnabled: weeklySummaryEnabled,
                monthlySummaryEnabled: monthlySummaryEnabled,
                whatsappShortcutEnabled: whatsappShortcutEnabled,
                defaultMessageTemplateId: defaultMessageTemplateId,
                extraJson: extraJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                Value<int> schemaVersion = const Value.absent(),
                Value<String> accountStatus = const Value.absent(),
                required String email,
                Value<String> displayName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> workshopName = const Value.absent(),
                Value<String?> workshopTagline = const Value.absent(),
                Value<String?> workshopAddress = const Value.absent(),
                Value<String?> workshopPhone = const Value.absent(),
                Value<String?> workshopEmail = const Value.absent(),
                Value<String?> workshopLogoUrl = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<double> invoiceTaxPercent = const Value.absent(),
                Value<String> invoiceCurrency = const Value.absent(),
                Value<String> invoiceCurrencySymbol = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> invoiceNextNumber = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> dailyReminderHour = const Value.absent(),
                Value<int> dailyReminderMinute = const Value.absent(),
                Value<bool> weeklySummaryEnabled = const Value.absent(),
                Value<bool> monthlySummaryEnabled = const Value.absent(),
                Value<bool> whatsappShortcutEnabled = const Value.absent(),
                Value<String?> defaultMessageTemplateId = const Value.absent(),
                Value<String?> extraJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                uid: uid,
                schemaVersion: schemaVersion,
                accountStatus: accountStatus,
                email: email,
                displayName: displayName,
                phone: phone,
                workshopName: workshopName,
                workshopTagline: workshopTagline,
                workshopAddress: workshopAddress,
                workshopPhone: workshopPhone,
                workshopEmail: workshopEmail,
                workshopLogoUrl: workshopLogoUrl,
                countryCode: countryCode,
                timezone: timezone,
                invoiceTaxPercent: invoiceTaxPercent,
                invoiceCurrency: invoiceCurrency,
                invoiceCurrencySymbol: invoiceCurrencySymbol,
                invoicePrefix: invoicePrefix,
                invoiceNextNumber: invoiceNextNumber,
                themeMode: themeMode,
                language: language,
                notificationsEnabled: notificationsEnabled,
                dailyReminderHour: dailyReminderHour,
                dailyReminderMinute: dailyReminderMinute,
                weeklySummaryEnabled: weeklySummaryEnabled,
                monthlySummaryEnabled: monthlySummaryEnabled,
                whatsappShortcutEnabled: whatsappShortcutEnabled,
                defaultMessageTemplateId: defaultMessageTemplateId,
                extraJson: extraJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfileRow,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfileRow,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileRow>,
      ),
      UserProfileRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$ServiceRecordsTableTableManager get serviceRecords =>
      $$ServiceRecordsTableTableManager(_db, _db.serviceRecords);
  $$MaintenanceRemindersTableTableManager get maintenanceReminders =>
      $$MaintenanceRemindersTableTableManager(_db, _db.maintenanceReminders);
  $$MessageTemplatesTableTableManager get messageTemplates =>
      $$MessageTemplatesTableTableManager(_db, _db.messageTemplates);
  $$ReminderHistoryTableTableManager get reminderHistory =>
      $$ReminderHistoryTableTableManager(_db, _db.reminderHistory);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$MaintenanceLogsTableTableManager get maintenanceLogs =>
      $$MaintenanceLogsTableTableManager(_db, _db.maintenanceLogs);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
}
