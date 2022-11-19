import { combineReducers } from 'redux';
  import { controlsReducer } from './controlsReducer';

export const rootReducer = combineReducers({
  storedPng: controlsReducer
});
