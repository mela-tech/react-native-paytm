interface PayTmPaymentDetails {
    orderId: string;
    mid: string;
    txnToken: string;
    amount: string;
    callbackUrl: string;
}

interface PaytmEvents {
    PAYTM_RESPONSE: 'PayTMResponse';
}

interface PaytmResponseIos {
    orderId: string;
    mid: string;
    txnToken: string;
    amount: string;
    callbackUrl: string;
}

interface PaytmResponseAndroid extends PaytmResponseIos {
    status: string;
}

export const Events: PaytmEvents;

export function startPayment(details: PayTmPaymentDetails): void;

export function addListener(event: string, handler: (response: PaytmResponseIos | PaytmResponseAndroid) => void): void;

export function removeListener(event: string, handler: (response: PaytmResponseIos | PaytmResponseAndroid) => void): void;
