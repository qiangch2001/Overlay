/****************************************************************************
** Meta object code from reading C++ file 'brightness.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../app/brightness.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'brightness.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Brightness_t {
    QByteArrayData data[9];
    char stringdata0[76];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Brightness_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Brightness_t qt_meta_stringdata_Brightness = {
    {
QT_MOC_LITERAL(0, 0, 10), // "Brightness"
QT_MOC_LITERAL(1, 11, 19), // "readScreenLuminance"
QT_MOC_LITERAL(2, 31, 0), // ""
QT_MOC_LITERAL(3, 32, 12), // "setAlgorithm"
QT_MOC_LITERAL(4, 45, 6), // "method"
QT_MOC_LITERAL(5, 52, 17), // "setUserRGBWeights"
QT_MOC_LITERAL(6, 70, 1), // "r"
QT_MOC_LITERAL(7, 72, 1), // "g"
QT_MOC_LITERAL(8, 74, 1) // "b"

    },
    "Brightness\0readScreenLuminance\0\0"
    "setAlgorithm\0method\0setUserRGBWeights\0"
    "r\0g\0b"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Brightness[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    0,   29,    2, 0x02 /* Public */,
       3,    1,   30,    2, 0x02 /* Public */,
       5,    3,   33,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Double,
    QMetaType::Void, QMetaType::Int,    4,
    QMetaType::Void, QMetaType::Double, QMetaType::Double, QMetaType::Double,    6,    7,    8,

       0        // eod
};

void Brightness::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Brightness *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { double _r = _t->readScreenLuminance();
            if (_a[0]) *reinterpret_cast< double*>(_a[0]) = std::move(_r); }  break;
        case 1: _t->setAlgorithm((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 2: _t->setUserRGBWeights((*reinterpret_cast< double(*)>(_a[1])),(*reinterpret_cast< double(*)>(_a[2])),(*reinterpret_cast< double(*)>(_a[3]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject Brightness::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_Brightness.data,
    qt_meta_data_Brightness,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Brightness::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Brightness::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Brightness.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Brightness::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 3;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
