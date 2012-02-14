var Bank = {
  parseClearingNumber: function(number) {
    return parseFloat(number);
  },

  bankNameFromClearingNumber: function(number) {
    var clr = this.parseClearingNumber(number);
    if (1100 <= clr && clr <= 1199) {
      return "Nordea";
    } else if (1400 <= clr && clr <= 2099) {
      return "Nordea";
    } else if (3000 <= clr && clr <= 3299) {
      return "Nordea";
    } else if (3301 <= clr && clr <= 3399) {
      return "Nordea";
    } else if (3410 <= clr && clr <= 3781) {
      return "Nordea";
    } else if (3783 <= clr && clr <= 4999) {
      return "Nordea";

    } else if (clr === 3300) {
      return "Nordea Personkonto";
    } else if (clr === 3782) {
      return "Nordea Personkonton";

    } else if (5000 <= clr && clr <= 5999) {
      return "SEB";
    } else if (9120 <= clr && clr <= 9124) {
      return "SEB";
    } else if (9130 <= clr && clr <= 9149) {
      return "SEB";

    } else if (7000 <= clr && clr <= 8104) {
      return "Swedbank";
    } else if (8106 <= clr && clr <= 8999) {
      return "Swedbank";

    } else if (9150 <= clr && clr <= 9169) {
      return "Skandiabanken";

    } else if (2300 <= clr && clr <= 2309) {
      return "JP Nordiska";
    } else if (2311 <= clr && clr <= 2399) {
      return "JP Nordiska";

    } else if (3400 <= clr && clr <= 3409) {
      return "Länsförsäkringar Bank";
    } else if (9020 <= clr && clr <= 9029) {
      return "Länsförsäkringar Bank";
    } else if (9060 <= clr && clr <= 9069) {
      return "Länsförsäkringar Bank";

    } else if (clr === 2310) {
      return "Ålandsbanken";

    } else if (6000 <= clr && clr <= 6999) {
      return "Handelsbanken";

    } else if (clr === 2950) {
      return "Sambox";
    } else if (clr === 8105) {
      return "Sambox";

    } else if (clr === 8264) {
      return "Sparbanken Nord";

    } else if (9040 <= clr && clr <= 9049) {
      return "Citibank";

    } else if (9059 <= clr && clr <= 9059) {
      return "HSB Bank";

    } else if (clr === 9080) {
      return "Calyon Bank";

    } else if (9090 <= clr && clr <= 9099) {
      return "ABN AMRO";

    } else if (clr === 9100) {
      return "Nordnet Bank";

    } else if (9170 <= clr && clr <= 9179) {
      return "Ikano Bank";

    } else if (1200 <= clr && clr <= 1399){
      return "Danske Bank";
    } else if (9180 <= clr && clr <= 9189) {
      return "Danske Bank";

    } else if (9190 <= clr && clr <= 9199) {
      return "Den Norske Bank";

    } else if (9200 <= clr && clr <= 9209) {
      return "Stadshypotek Bank";

    } else if (clr === 9230) {
      return "Bank2";

    } else if (9231 <= clr && clr <= 9239) {
      return "SalusAnsvar Bank";

    } else if (9260 <= clr && clr <= 9269) {
      return "Gjensidige NOR Sparebank";

    } else if (9270 <= clr && clr <= 9279) {
      return "ICA Banken";

    } else if (9280 <= clr && clr <= 9289) {
      return "Resurs Bank";

    } else if (9290 <= clr && clr <= 9299) {
      return "Coop Bank";

    } else if (9300 <= clr && clr <= 9329) {
      return "Sparbanken Finn";

    } else if (9330 <= clr && clr <= 9349) {
      return "Sparbanken Gripen";

    } else if (clr === 9400) {
      return "Forex Bank";

    } else if (clr === 9460) {
      return "GE Money Bank";
    } else if (clr === 9469) {
      return "GE Money Bank";

    } else if (9500 <= clr && clr <= 9547) {
      return "Plusgirot Bank";
    } else if (9960 <= clr && clr <= 9969) {
      return "Plusgirot Bank";

    } else if (clr === 9548) {
      return "Ekobanken";

    } else if (clr === 9549) {
      return "JAK Medlemsbank";

    } else if (clr === 9550) {
      return "Avanza Bank";

    } else {
      return "Okänd";
    }
  },
  
  updateBankName: function(field, number) {
    if (number) {
      document.getElementById(field).value = this.bankNameFromClearingNumber(number);
    }
  }
};

