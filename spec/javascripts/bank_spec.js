//= require jquery
//= require bank

var banks = [{ name: "Amfa Bank AB", range: "9660 - 9669" },
{ name: "Avanza Bank AB", range: "9550 - 9569" },
{ name: "BNP Paribas Fortis Bank", range: "9470 - 9479" },
{ name: "Citibank", range: "9040 - 9049" },
{ name: "Danske Bank", range: "1200 - 1399" },
{ name: "Danske Bank", range: "2400 - 2499" },
{ name: "DNB Bank", range: "9190 - 9199" },
{ name: "DNB Bank", range: "9260 - 9269" },
{ name: "Erik Penser AB", range: "9590 – 9599" },
{ name: "Forex Bank", range: "9400 - 9449" },
{ name: "GE Money Bank", range: "9460 - 9469" },
{ name: "ICA Banken AB", range: "9270 - 9279" },
{ name: "IKANO Bank", range: "9170 - 9179" },
{ name: "Landshypotek AB", range: "9390 - 9399" },
{ name: "Länsförsäkringar Bank", range: "3400 - 3409" },
{ name: "Länsförsäkringar Bank", range: "9020 - 9029" },
{ name: "Länsförsäkringar Bank", range: "9060 - 9069" },
{ name: "Marginalen Bank", range: "9230 - 9239" },
{ name: "Nordax Finans AB", range: "9640 - 9649" },
{ name: "Nordea", range: "1100 - 1199" },
{ name: "Nordea", range: "1400 - 2099" },
{ name: "Nordea", range: "3000 - 3399" },
{ name: "Nordea", range: "3410 - 4999" },
{ name: "Nordea Personkonton", range: "3300" },
{ name: "Nordea Personkonton", range: "3782" },
{ name: "Nordnet Bank", range: "9100 - 9109" },
{ name: "Resurs Bank", range: "9280 - 9289" },
{ name: "Riksgälden", range: "9880 - 9899" },
{ name: "Royal bank of Scotland", range: "9090 - 9099" },
{ name: "SBAB", range: "9250 - 9259" },
{ name: "SEB", range: "5000 - 5999" },
{ name: "SEB", range: "9120 - 9124" },
{ name: "SEB", range: "9130 - 9149" },
{ name: "Skandiabanken", range: "9150 - 9169" },
{ name: "Swedbank", range: "7000 - 8999" },
{ name: "Ålandsbanken Sverige AB", range: "2300 - 2399 " },
{ name: "Danske Bank", range: "9180 - 9189" },
{ name: "Handelsbanken", range: "6000 - 6999" },
{ name: "Nordea/Plusgirot", range: "9500 - 9549" },
{ name: "Nordea/Plusgirot", range: "9960 - 9969"},
{ name: "Sparbanken Öresund AB", range: "9300 - 9349" },
{ name: "Sparbanken Syd", range: "9570 - 9579" }];

describe("Bank", function() {
  it("gets loaded", function() {
    expect(window.Bank).to.not.be(undefined);
  });

  describe(".banks", function() {
    it("lists banks alphabetically", function() {
      var bankNames = Bank.banks.map(function(bank) { return bank.name; });
      expect(bankNames).to.equal(bankNames.sort());
    });
  });

  describe(".bankNameFromClearingNumber", function() {
    var fn = function(number) {
      return Bank.bankNameFromClearingNumber(number);
    };
    banks.forEach(function(bank) {
      it("resolves to " + bank.name + " for " + bank.range, function() {
        if (bank.range.indexOf("-") > 0) { // range
          var ranges = bank.range.split(" - ");
          var min = parseInt(ranges[0], 10);
          var max = parseInt(ranges[1], 10);

          expect(fn(min - 1)).to.not.equal(bank.name);

          expect(fn(min)).to.equal(bank.name);
          expect(fn(max)).to.equal(bank.name);

          expect(fn(max + 1)).to.not.equal(bank.name);
        } else { // exact clearing number
          var clr = parseInt(bank.range, 10);
          expect(fn(clr - 1)).to.not.equal(bank.name);

          expect(fn(clr)).to.equal(bank.name);

          expect(fn(clr - 1)).to.not.equal(bank.name);
        }
      });
    });
  });
});

