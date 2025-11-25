// src/components/PlaidLinkButton.jsx
import React from "react";
import { usePlaidLink } from "react-plaid-link";

export default function PlaidLinkButton({
  linkToken,
  onSuccess,
  disabled,
  className,
  children,
}) {
  // If no token yet, show a disabled loading button
  if (!linkToken) {
    return (
      <button type="button" className={className} disabled>
        Loading…
      </button>
    );
  }

  const config = {
    token: linkToken,
    onSuccess, // (public_token, metadata) => ...
  };

  const { open, ready } = usePlaidLink(config);

  const isDisabled = disabled || !ready;

  return (
    <button
      type="button"
      className={className}
      onClick={() => open()}
      disabled={isDisabled}
    >
      {children}
    </button>
  );
}
