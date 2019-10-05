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

export function startPayment(details: PayTmPaymentDetails): void;

export function addListener(event: string, handler: (response) => void): void;

export function removeListeners(): void;
