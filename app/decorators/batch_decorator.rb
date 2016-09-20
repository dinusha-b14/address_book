class BatchDecorator < Draper::Decorator
  delegate_all

  def iconified_status
    case status
    when BatchStatus::PROCESSING
      processing_status
    when BatchStatus::COMPLETE
      complete_status
    when BatchStatus::FAILED
      failed_status
    else
      created_status
    end
  end

  private

  def processing_status
    h.render partial: 'batch/shared/processing_status', locals: { status: translated_status }
  end

  def complete_status
    h.render partial: 'batch/shared/complete_status', locals: { status: translated_status }
  end

  def failed_status
    h.render partial: 'batch/shared/failed_status', locals: { status: translated_status }
  end

  def created_status
    h.render partial: 'batch/shared/created_status', locals: { status: translated_status }
  end

  def translated_status
    BatchStatus.t(status)
  end
end
