// List of banks fetched from BankGiroCentralen (last updated 2015-01-27):
//   http://www.bgc.se/upload/Gemensamt/Trycksaker/Manualer/BG910.pdf
var Bank = {
  banks: [
    {
      conditions: [ { min: 9550, max: 9569 } ],
      name: "Avanza Bank AB" },
    {
      conditions: [ { min: 9660, max: 9669 } ],
      name: "Amfa Bank AB"},
    {
      conditions: [ { min: 9470, max: 9479 } ],
      name: "BNP Paribas Fortis Bank"},
    {
      conditions: [ { min: 9040, max: 9049 } ],
      name: "Citibank" },
    {
      conditions: [ { clr: 9080 } ],
      name: "Calyon Bank" },
    {
      conditions: [ { min: 9290, max: 9299 } ],
      name: "Coop Bank" },
    {
      conditions: [ { min: 1200, max: 1399 },
                    { min: 2400, max: 2499 },
                    { min: 9180, max: 9189 } ],
      name: "Danske Bank" },
    {
      conditions: [ { min: 9190, max: 9199 }, { min: 9260, max: 9269 } ],
      name: "DNB Bank"},
    {
      conditions: [ { min: 9590, max: 9599 } ],
      name: "Erik Penser AB" },
    {
      conditions: [ { min: 9400, max: 9449 } ],
      name: "Forex Bank" },
    {
      conditions: [ { clr: 9460 }, { clr: 9469 } ],
      name: "GE Money Bank" },
    {
      conditions: [ { min: 9260, max: 9169 } ],
      name: "Gjensidige NOR Sparebank" },
    {
      conditions: [ { min: 6000, max: 6999 } ],
      name: "Handelsbanken" },
    {
      conditions: [ { clr: 9059 } ],
      name: "HSB Bank" },
    {
      conditions: [ { min: 9270, max: 9279 } ],
      name: "ICA Banken AB" },
    {
      conditions: [ { min: 9170, max: 9179 } ],
      name: "IKANO Bank" },
    {
      conditions: [ { min: 9390, max: 9399 } ],
      name: "Landshypotek AB"},
    {
      conditions: [ { min: 3400, max: 3409 },
                    { min: 9020, max: 9029 },
                    { min: 9060, max: 9069 }],
      name: "Länsförsäkringar Bank"},
    {
      conditions: [ { min: 9230, max: 9239 } ],
      name: "Marginalen Bank"},
    {
      conditions: [ { min: 9640, max: 9649 } ],
      name: "Nordax Finans AB"},
    {
      conditions: [ { clr: 3300 }, { clr: 3782 } ],
      name: "Nordea Personkonton" },
    {
      conditions: [
        { min: 1100, max: 1199 }, { min: 1400, max: 2099 },
        { min: 3000, max: 3299 }, { min: 3301, max: 3399 },
        { min: 3410, max: 4999 } ],
      name: "Nordea" },
    {
      conditions: [ { min: 9100, max: 9109 } ],
      name: "Nordnet Bank" },
    {
      conditions: [ { min: 9500, max: 9549 }, { min: 9960, max: 9969 } ],
      name: "Nordea/Plusgirot" },
    {
      conditions: [ { min: 9280, max: 9289 } ],
      name: "Resurs Bank" },
    {
      conditions: [ { min: 9880, max: 9899 } ],
      name: "Riksgälden"},
    {
      conditions: [ { min: 9090, max: 9099 } ],
      name: "Royal bank of Scotland"},
    {
      conditions: [ { clr: 2950 }, { clr: 8105 } ],
      name: "Sambox" },
    {
      conditions: [ { min: 9250, max: 9259 } ],
      name: "SBAB"},
    {
      conditions: [
        { min: 5000, max: 5999 },
        { min: 9120, max: 9124 },
        { min: 9130, max: 9149 }, ],
      name: "SEB" },
    {
      conditions: [ { min: 9150, max: 9169 } ],
      name: "Skandiabanken" },
    {
      conditions: [ { min: 9200, max: 9209 } ],
      name: "Stadshypotek Bank" },
    {
      conditions: [ { clr: 8264 }],
      name: "Sparbanken Nord" },
    {
      conditions: [ { min: 9570, max: 9579 } ],
      name: "Sparbanken Syd"},
    {
      conditions: [ { min: 9300, max: 9349 } ],
      name: "Sparbanken Öresund AB" },
    {
      conditions: [ { min: 7000, max: 8104 }, { min: 8106, max: 8999 } ],
      name: "Swedbank" },
    {
      conditions: [ { min: 2300, max: 2399 } ],
      name: "Ålandsbanken Sverige AB"}
  ],

  bankNameFromClearingNumber: function bankNameFromClearingNumber(number) {
    // Filter out matching conditions
    function clearingNumberFilter(cond) {
      var clr = parseInt(number, 10);
      return !!cond.clr && cond.clr === clr ||   // match exact clr
            cond.min <= clr && cond.max >= clr; // match in range
    }

    // Filter out banks matching a specific clearing number
    function bankFilter(banks) {
      var filter = banks.conditions.filter(clearingNumberFilter);
      return filter.length > 0;
    }

    var bank = this.banks.filter(bankFilter)[0];
    return bank && bank.name;
  },

  updateBankName: function updateBankName(field, number) {
    if (number) {
      document.getElementById(field).value =
        this.bankNameFromClearingNumber(number);
    }
  }
};

