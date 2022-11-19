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

export const incrementModel = value => ({
  type: INCREMENT_MODEL,
  payload: value
});

export const decrementModel = value => ({
  type: DECREMENT_MODEL,
  payload: value
});

export const incrementColor = value => ({
  type: INCREMENT_COLOR,
  payload: value
});

export const decrementColor = value => ({
  type: DECREMENT_COLOR,
  payload: value
});

export const incrementSpoiler = value => ({
  type: INCREMENT_SPOILER,
  payload: value
});

export const decrementSpoiler = value => ({
  type: DECREMENT_SPOILER,
  payload: value
});


export const incrementStickers = value => ({
  type: INCREMENT_STICKERS,
  payload: value
});

export const decrementStickers = value => ({
  type: DECREMENT_STICKERS,
  payload: value
});

export const incrementRims = value => ({
  type: INCREMENT_RIMS,
  payload: value
});

export const decrementRims = value => ({
  type: DECREMENT_RIMS,
  payload: value
});
