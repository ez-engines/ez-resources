module Ez
  module Resources
    class FormCell < ApplicationCell
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::DateHelper
      include SimpleForm::ActionViewExtensions::FormHelper
      include ActionView::RecordIdentifier
      include ActionView::Helpers::FormOptionsHelper

      def form_header_label
        if model.data.new_record?
          "#{t('actions.new')} #{model.resource_name.downcase}"
        else
          "#{t('actions.edit')} #{model.data.public_send(model.resource_label)} #{model.resource_name.downcase}"
        end
      end

      def submit_button_text
        if model.data.new_record?
          t('actions.create')
        else
          t('actions.update')
        end
      end
    end
  end
end
