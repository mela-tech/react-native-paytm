interface PayTmPaymentDetails {
    mode: 'Staging' | 'Production';
    MID: string;
    INDUSTRY_TYPE_ID: string;
    WEBSITE: string;
    CHANNEL_ID: string;
    TXN_AMOUNT: string;
    ORDER_ID: string;
    EMAIL?: string;
    MOBILE_NO?: string;
    CUST_ID: string;
    CHECKSUMHASH: string;
    CALLBACK_URL: string;
    MERC_UNQ_REF?: string;
}

interface PaytmEvents {
    PAYTM_RESPONSE: 'PayTMResponse';
}

interface PaytmResponseIos {
    ORDERID: string;
    MID: string;
    TXNID: string;
    TXNAMOUNT: string;
    PAYMENTMODE: string;
    CURRENCY: string;
    TXNDATE: string;
    STATUS: string;
    RESPCODE: string;
    RESPMSG: string;
    GATEWAYNAME: string;
    BANKTXNID: string;
    BANKNAME: string;
    CHECKSUMHASH: string;
}

interface PaytmResponseAndroid {
    ORDERID: string;
    MID: string;
    TXNID: string;
    TXNAMOUNT: string;
    PAYMENTMODE: string;
    CURRENCY: string;
    TXNDATE: string;
    STATUS: string;
    RESPCODE: string;
    RESPMSG: string;
    GATEWAYNAME: string;
    BANKTXNID: string;
    BANKNAME: string;
    CHECKSUMHASH: string;
}

export const Events: PaytmEvents;

export function startPayment(details: PayTmPaymentDetails): void;

export function addListener(event: string, handler: (response) => void): void;

export function removeListener(event: string, handler: (response) => void): void;
