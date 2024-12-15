// 患者表
const patientsTableCreateSql = '''
CREATE TABLE Patients (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Gender TEXT CHECK (Gender IN ('Male', 'Female', 'Other')),
    DateOfBirth DATE,
    ContactInfo TEXT,
    UpdateTime DATE NOT NULL DEFAULT CURRENT_DATE
);
''';

// 药品库存表
const medicationStockTableCreateSql = '''
CREATE TABLE MedicationStock (
    MedicationName TEXT PRIMARY KEY,
    StockQuantity REAL NOT NULL CHECK (StockQuantity >= 0),
    Unit TEXT NOT NULL, -- 如“片”、“瓶”等
    AveragePrice REAL NOT NULL CHECK (AveragePrice >= 0), -- 药品均价
    UpdateTime DATE NOT NULL DEFAULT CURRENT_DATE
);
''';

// 药品出入库记录
const medicationStockRecordsTableCreateSql = '''
CREATE TABLE MedicationStockRecord (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    MedicationName TEXT NOT NULL,
    Quantity REAL NOT NULL, -- 入库数量
    UnitPrice REAL, -- 入库单价
    TotalPrice REAL, -- 计算字段，记录总金额
    EntryDate DATE NOT NULL DEFAULT CURRENT_DATE, -- 入库日期
    Operation INTEGER NOT NULL, -- 操作类型
    FOREIGN KEY (MedicationName) REFERENCES MedicationStock(MedicationName)
);
''';

// 处方
const prescriptionsTableCreateSql = '''
CREATE TABLE Prescriptions (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    PatientID INTEGER NOT NULL,
    PrescriptionDate DATE NOT NULL,
    Notes TEXT,
    UpdateTime DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(Id)
);
''';

// 处方详情
const prescriptionDetailsTableCreateSql = '''
CREATE TABLE PrescriptionDetails (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    PrescriptionID INTEGER NOT NULL,
    MedicationName TEXT NOT NULL,
    Quantity INTEGER NOT NULL CHECK (Quantity > 0),
    Dosage TEXT,
    Instructions TEXT,
    UpdateTime DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (PrescriptionID) REFERENCES Prescriptions(Id),
    FOREIGN KEY (MedicationName) REFERENCES MedicationStock(MedicationName)
);
''';

const prescriptionDescriptionsTableCreateSql = '''
CREATE TABLE PrescriptionDescriptions (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    PrescriptionID INTEGER NOT NULL,
    Type INTEGER NOT NULL,
    Description TEXT NOT NULL,
    UpdateTime DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (PrescriptionID) REFERENCES Prescriptions(Id)
);
''';
