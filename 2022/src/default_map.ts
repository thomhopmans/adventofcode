class DefaultMap extends Map {
  getDefaultValue: string | number;

  constructor(getDefaultValue: string | number) {
    super();
    this.getDefaultValue = getDefaultValue;
  }

  get = (key: string | number) => {
    if (!this.has(key)) {
      this.set(key, this.getDefaultValue);
    }
    return super.get(key);
  };
}

export {DefaultMap};
