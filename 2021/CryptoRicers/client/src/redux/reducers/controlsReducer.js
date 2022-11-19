import {
  INCREMENT_MODEL,
  DECREMENT_MODEL,
  INCREMENT_COLOR,
  DECREMENT_COLOR,
  INCREMENT_SPOILER,
  DECREMENT_SPOILER,
  INCREMENT_STICKERS,
  DECREMENT_STICKERS,
  INCREMENT_RIMS,
  DECREMENT_RIMS
} from '../types';

let initialState = {model: 0, color: 0, spoiler: 0, stickers: 0, rims: 0};

export const controlsReducer = (state = initialState, action) => {
  switch (action.type) {
    case INCREMENT_MODEL:
    case DECREMENT_MODEL:
      return {...state, model: action.payload};

    case INCREMENT_COLOR:
    case DECREMENT_COLOR:
      return {...state, color: action.payload};

    case INCREMENT_SPOILER:
    case DECREMENT_SPOILER:
      return {...state, spoiler: action.payload};

    case INCREMENT_STICKERS:
    case DECREMENT_STICKERS:
      return {...state, stickers: action.payload};

    case INCREMENT_RIMS:
    case DECREMENT_RIMS:
      return {...state, rims: action.payload};

    default:
      return state;
  }
};
