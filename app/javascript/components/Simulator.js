import React, { Fragment } from 'react';
import axios from 'axios';
import _ from 'lodash';

class Simulator extends React.Component {

  state = {
    response:       '...loading',
    response_error: '',
    form_submitted: false,
    clean_data: '...loading'
  }

  componentDidMount() {
    // build the data
    this.personInfo(this.props);

    if(this.state.form_submitted) {
      this.postData()
    }
  }

  // API Calls
  axios(q) {
    return axios
      .get(`http://api.rules.nz/${q}`)
      .then(res => res)
      .catch(err => err)
  }

  postData(data) {
    setTimeout(() => {
      return axios.post('https://api.rules.nz/calculate', data)
        .then(res => this.setState({clean_data: data, response: res.data, response_error: ''}))
        .catch(err => this.setState({response_error: err.response.data, response: ''}))
    }, 3000);
  }

  // Data manipulation
  personInfo(props) {
    let persons = [];
    let variables = [];
    let definition_periods = [];
    let persons_inputs;
    let newObject = {};

    if(props.inputs.persons) {
      persons_inputs = _.values(_.values(props.inputs.persons));
      _.forIn(props.inputs.persons, (_value, key) => {
        persons.push(key);
        variables.push([]);
        definition_periods.push([]);
      });
      this.scenariosWithPersons(persons_inputs, persons, newObject, props);
    } else {
      this.scenariosWithoutPersons(newObject, 'Anaru', props);
    }
  }

  scenariosWithoutPersons(newObject, person, props) {
    newObject['persons'] = {};
    newObject['persons'][person] = {};
    _.keys(props.inputs).forEach((input_key, i) => {
      newObject['persons'][person] = {};
      let value = _.isObject(_.values(props.inputs)[i]) ? _.values(_.values(props.inputs)[i])[0] : _.values(props.inputs)[i];
      this.getDefinitionPeriod(input_key, newObject, person, value, false);
    });
    _.keys(props.outputs).forEach(o => {
      newObject['persons'][person][o] = {};
      this.getDefinitionPeriod(o, newObject, person, null, false);
    });
    this.postData(newObject);
  }

  scenariosWithPersons(persons_inputs, persons, newObject, props) {
    persons_inputs.forEach((pi, i) => {
      let person = persons[i];
      newObject[person] = {};
      // adding variables
      _.keys(pi).forEach((input_key, i) => {
        let input_value = _.values(pi)[i];
        let input_val_comp = _.isObject(input_value) ? _.values(input_value)[0] : input_value;
        newObject[person][input_key] = {};
        this.getDefinitionPeriod(input_key, newObject, person, input_val_comp, true);
      });
      let output_key = _.keys(props.outputs)[0];
      // adding outputs
      newObject[person][output_key] = {};
      this.getDefinitionPeriod(output_key, newObject, person, null, true);
      props.inputs.persons = newObject;
      this.postData(props.inputs);
    });
  }

  getDefinitionPeriod(key, newObject, person, value, hasPersons) {
    this.axios(`variable/${key}`)
      .then(res => {
        if(hasPersons) {
          newObject[person][key][this.definitionPeriod(res.data.definitionPeriod)] = value;
        } else {
          newObject['persons'][person][key] = {};
          newObject['persons'][person][key][this.definitionPeriod(res.data.definitionPeriod)] = value;
        }
      });
  }

  definitionPeriod(dp) {
    const dp_date = "2018";
    switch(dp) {
      case "DAY":
        return dp_date + "-01-01";
        break;
      case "MONTH":
        return dp_date + "-02";
        break;
      case "ETERNITY":
        return dp_date + "-03";
        break;
      case "YEAR":
        return dp_date;
        break;
    }
  }

  stringifyCode(state) {
    return JSON.stringify(state, null, 2)
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    this.setState({form_submitted: true});
    this.postData(JSON.parse(this.state.value))
    event.preventDefault();
  }

  render() {
    const { response, response_error } = this.state;
    return (
      <div className="simulator">
        <form onSubmit={this.handleSubmit.bind(this)}>
          <label aria-label="Textarea to add or modify code">
            <textarea
              name="code"
              rows="25"
              value={this.state.value ? this.state.value : this.stringifyCode(this.state.clean_data)}
              onChange={e => this.handleChange(e)}
            ></textarea>
          </label>
          {this.state.value && <input type="submit" className="btn" value="Submit" aria-label="Submit" />}
        </form>
        <RenderCode
          title={response_error !== '' ? 'Error' : 'Response'}
          code={this.stringifyCode(response_error !== '' ? response_error : response)}
        />
      </div>
    );
  }
}

const RenderCode = props => {
  return (
    <Fragment>
      <h3 className="sub-heading">{props.title}</h3>
      <code>
        <pre>
          {props.code}
        </pre>
      </code>
    </Fragment>
  )
}

export default Simulator;
