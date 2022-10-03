$(() => {
    const { attachGeocoding } = window.Decidim;

    window.DecidimProposals = window.DecidimProposals || {};

    window.DecidimProposals.bindProposalAddress = () => {
        const $checkbox = $("input:checkbox[name$='[has_address]']");
        const $addressInput = $("#address_input");
        const $addressInputField = $("input", $addressInput);

        if ($addressInput.length > 0) {
            attachGeocoding($addressInputField);
        }
    };

    window.DecidimProposals.bindProposalAddress();
});