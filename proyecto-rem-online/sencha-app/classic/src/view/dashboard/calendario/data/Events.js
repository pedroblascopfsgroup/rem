Ext.define('Ext.calendar.data.Events', {

    statics: {
        getData: function() {
            var today = Ext.Date.clearTime(new Date()), 
                makeDate = function(d, h, m, s) {
                    d = d * 86400;
                    h = (h || 0) * 3600;
                    m = (m || 0) * 60;
                    s = (s || 0);
                    return Ext.Date.add(today, Ext.Date.SECOND, d + h + m + s);
                };
                
            return {
                /*"evts": [{
                    "id": 1001,
                    "cid": 1,
                    "title": "Verificar datos cliente",
                    "start": makeDate(-7,-12),  
                    "end": makeDate(-7,12),
                    "notes": "Solicitud cliente Web"
                }, {
                    "id": 1002,
                    "cid": 2,
                    "title": "Resultado contacto con cliente",
                    "start": makeDate(-7),
                    "end": makeDate(-7)
                }, {
                    "id": 1003,
                    "cid": 3,
                    "title": "Visita cliente",
                    "start": makeDate(-2),
                    "end": makeDate(-2)
                }, {
                    "id": 1004,
                    "cid": 1,
                    "title": "Verificar resultado visita",
                    "start": makeDate(-1),
                    "end": makeDate(-1)
                },
                {
                    "id": 1006,
                    "cid": 2,
                    "title": "Reflejar contenido oferta",
                    "start": makeDate(-3),
                    "end": makeDate(-3)
                }, {
                    "id": 1007,
                    "cid": 3,
                    "title": "Ver Oferta",
                    "start": makeDate(0),
                    "end": makeDate(0)
                }, {
                    "id": 1008,
                    "cid": 3,
                    "title": "Verificar datos cliente",
                    "start": makeDate(1),
                    "end": makeDate(1),
                    "ad": true
                }, {
                    "id": 1009,
                    "cid": 1,
                    "title": "Comprobación estado inmueble",
                    "start": makeDate(4),
                    "end": makeDate(4),
                    "loc": "ABC Inc.",
                    "rem": "60"
                }, {
                    "id": 1010,
                    "cid": 2,
                    "title": "Avisar cliente cancelación visita",
                    "start": makeDate(5),
                    "end": makeDate(6)
                }, {
                    "id": 1011,
                    "cid": 1,
                    "title": "Visita del cliente",
                    "start": makeDate(6),
                    "end": makeDate(6)
                }]*/
            };
        }
    }
});