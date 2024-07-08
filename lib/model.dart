class Exchange {
  Status? status;
  Errors? errors;
  Params? params;
  Data? data;
  Pagination? pagination;

  Exchange({this.status, this.errors, this.params, this.data, this.pagination});

  Exchange.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) :null;
    errors =
    json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    params =
    json['params'] != null ? new Params.fromJson(json['params']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    if (this.params != null) {
      data['params'] = this.params!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Status {
  int? code;

  Status({this.code});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

class Errors {
  Null? validation;

  Errors({this.validation});

  Errors.fromJson(Map<String, dynamic> json) {
    validation = json['validation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['validation'] = this.validation;
    return data;
  }
}

class Params {
  Null? date;
  String? from;
  String? to;
  Null? postType;
  String? perPage;
  String? page;
  Null? slug;
  Null? q;

  Params(
      {this.date,
        this.from,
        this.to,
        this.postType,
        this.perPage,
        this.page,
        this.slug,
        this.q});

  Params.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    from = json['from'];
    to = json['to'];
    postType = json['post_type'];
    perPage = json['per_page'];
    page = json['page'];
    slug = json['slug'];
    q = json['q'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['from'] = this.from;
    data['to'] = this.to;
    data['post_type'] = this.postType;
    data['per_page'] = this.perPage;
    data['page'] = this.page;
    data['slug'] = this.slug;
    data['q'] = this.q;
    return data;
  }
}

class Data {
  List<Payload>? payload;

  Data({this.payload});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['payload'] != null) {
      payload = <Payload>[];
      json['payload'].forEach((v) {
        payload!.add(new Payload.fromJson(v));
      });
    }
    else{
      payload = <Payload>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  String? date;
  String? publishedOn;
  String? modifiedOn;
  List<Rates>? rates;

  Payload({this.date, this.publishedOn, this.modifiedOn, this.rates});

  Payload.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    publishedOn = json['published_on'];
    modifiedOn = json['modified_on'];
    if (json['rates'] != null) {
      rates = <Rates>[];
      json['rates'].forEach((v) {
        rates!.add(new Rates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['published_on'] = this.publishedOn;
    data['modified_on'] = this.modifiedOn;
    if (this.rates != null) {
      data['rates'] = this.rates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rates {
  Currency? currency;
  String? buy;
  String? sell;

  Rates({this.currency, this.buy, this.sell});

  Rates.fromJson(Map<String, dynamic> json) {
    currency = json['currency'] != null
        ? new Currency.fromJson(json['currency'])
        : null;
    buy = json['buy'];
    sell = json['sell'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currency != null) {
      data['currency'] = this.currency!.toJson();
    }
    data['buy'] = this.buy;
    data['sell'] = this.sell;
    return data;
  }
}

class Currency {
  String? iso3;
  String? name;
  int? unit;

  Currency({this.iso3, this.name, this.unit});

  Currency.fromJson(Map<String, dynamic> json) {
    iso3 = json['iso3'];
    name = json['name'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso3'] = this.iso3;
    data['name'] = this.name;
    data['unit'] = this.unit;
    return data;
  }
}

class Pagination {
  int? page;
  int? pages;
  int? perPage;
  int? total;
  Links? links;

  Pagination({this.page, this.pages, this.perPage, this.total, this.links});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pages = json['pages'];
    perPage = json['per_page'];
    total = json['total'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pages'] = this.pages;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    return data;
  }
}

class Links {
  String? prev;
  String? next;

  Links({this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    prev = json['prev']==null?"null":json['prev'];
    next = json['next']==null?"null":json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}
